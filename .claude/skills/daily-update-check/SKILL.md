---
name: daily-update-check
description: Daily procedure for discovering, validating, and bumping upstream dependency versions in the JustRails8 bootstrapper (Rails, Ruby, MaglevCMS, HyperUI, Node.js, Yarn, system packages). Invoked by the daily cron via `claude -p "run the daily update check"`.
triggers:
  - "run the daily update check"
  - "check for dependency updates"
  - "bump upstream versions"
---

# Daily Update Check

This skill codifies the daily routine for keeping the JustRails8 bootstrapper up to date with upstream dependencies. It runs unattended under a cron job that invokes `claude -p "run the daily update check"`.

## Scope

Dependencies this bootstrapper pins (and the files that pin them):

| Dependency                    | Current pin                       | Pinned in                         |
|-------------------------------|-----------------------------------|-----------------------------------|
| Ruby base image               | `ruby:4.0.6-slim`                 | `just-rails-8/Dockerfile` line 1  |
| Rails gem                     | `~> 8.1`                          | `just-rails-8/Dockerfile` line 18 |
| MaglevCMS                     | `~> 3.0.0`                        | `just-rails-8/setup.sh` line 26   |
| MaglevCMS HyperUI Kit         | `~> 2.0.0`                        | `just-rails-8/setup.sh` line 27   |
| Node.js (apt via nodesource)  | `22.x` LTS                        | `just-rails-8/setup.sh` line 20   |
| Yarn (global npm)             | latest (no pin)                   | `just-rails-8/setup.sh` line 22   |
| system apt packages           | `sqlite3 libsqlite3-dev libvips libyaml-dev libmsgpack-dev build-essential git-core` | `just-rails-8/Dockerfile` lines 5–12 |
| rdoc gem path cleanup         | `4.0.0` (Ruby ABI)                | `just-rails-8/Dockerfile` lines 19–21 |

Update this table whenever a bump lands (commit message should reference the change).

## Procedure

Run the following steps in order. Stop early if a step requires human input (see "Abort conditions" below).

### Step 1 — Gather latest versions

Run each check command and capture its output. Keep a `versions.md` in the repo root (gitignored, ephemeral) with the results for this run.

| Dependency | Check command |
|------------|----------------|
| Rails gem       | `gem search rails --remote --exact` — take highest `X.Y.Z` line |
| Ruby image tag  | `curl -s 'https://registry.hub.docker.com/v2/repositories/library/ruby/tags/?page_size=25&name=4.0' \| jq -r '.results[].name' \| grep -E '^4\.0\.[0-9]+-slim$' \| sort -V \| tail -1` |
| MaglevCMS       | `gem search maglevcms --remote --exact` |
| Maglev-HyperUI  | `gem search maglevcms-hyperui-kit --remote --exact` |
| Node.js 22 LTS  | `curl -s https://nodejs.org/dist/index.json \| jq -r '[.[] \| select(.version \| startswith("v22."))] \| first \| .version'` |
| Yarn            | `npm view yarn version` |

### Step 2 — Diff against the table above

Compare each "latest" value to the pinned value in the table. If nothing has moved past the current pessimistic constraint, **there is no update to apply** — write "no updates" to `versions.md`, skip to Step 6, and exit.

A minor/patch bump within `~> 8.1` (e.g. `8.1.3` → `8.1.4`) is **auto-eligible**: Rails' pessimistic constraint already resolves it via `bundle install`. No Dockerfile change needed for pure patch-level Rails updates — they ride on the existing `~> 8.1` pin.

A **minor-major bump** (e.g. `8.1` → `8.2`, Ruby `4.0` → `4.1`, Maglev `3.0` → `3.1`) **requires human review** before committing. Continue to Step 3 only to collect evidence; do not edit files in that case.

### Step 3 — Verify compatibility (maglev only)

MaglevCMS pins its Rails and HyperUI companions tightly. Before bumping any of the three:

1. Read MaglevCMS release notes: `curl -sL https://rubygems.org/gems/maglevcms/versions | grep -A2 "<release>"` or browse https://rubygems.org/gems/maglevcms.
2. Confirm supported Rails major version in the gemspec. Cross-check https://github.com/maglevcms/maglev-rails README.
3. Confirm HyperUI kit compatibility matrix (HyperUI 2.x ↔ Maglev 3.x currently).

If MaglevCMS does not yet support the new Rails major, **skip the Rails bump** and note the blocker.

### Step 4 — Apply the bump (only if auto-eligible)

For each auto-eligible bump:

1. Edit the pinned file (`Dockerfile` or `setup.sh`) with the new version.
2. Rebuild and run the end-to-end test:
   ```bash
   ./just-rails-8/reset.sh --clean-untracked
   ./just-rails-8/test.sh
   ```
   `test.sh` exercises both flavors (vanilla and maglev), waits up to 480s for boot, and asserts HTTP 200 on root plus maglev editor reachability.
3. If test passes:
   ```bash
   git add -A
   git commit -m "chore(deps): bump <name> <old> → <new>

   Verified via ./just-rails-8/test.sh — both flavors pass."
   git push
   ```
4. If test fails: revert the edit (`git checkout -- <file>`) and proceed to Step 5.

### Step 5 — Report blockers

If any bump fails tests or requires human review, append a section to `versions.md`:

```
## <date>
- Rails 8.1.3 → 8.2.0   — BLOCKED: maglevcms gemspec requires < 8.2
- Ruby   4.0.3 → 4.0.4   — applied, test.sh PASS
- Yarn   1.22.22 latest   — no change (unpinned)
- Node   22.12.0 → 22.13.0 — BLOCKED: nodesource setup_22.x script returns 404 for 22.13
```

### Step 6 — Cleanup

Remove the ephemeral `versions.md` unless blockers were recorded. If blockers exist, leave it for the next run to append to.

Run `git status` to confirm working tree is clean (all applied bumps committed and pushed).

## Abort conditions

Stop and surface to the user (via stdout — the cron log) if:

- Docker daemon is unreachable (`docker info` fails)
- `gem search` returns network errors for two consecutive retries
- `./just-rails-8/test.sh` fails on an **unmodified** state (i.e. HEAD itself is broken) — this signals a rot in base images unrelated to dep bumps
- MaglevCMS and Rails major versions are out of sync after a bump attempt (Dockerfile line 18 says `~> 8.2` but `maglevcms ~> 3.0.0` resolves to a version that forbids 8.2)

## Notes for the invoking cron

- Expected runtime: ~10 minutes when updates apply (dominated by `test.sh`), ~2 minutes when no updates apply.
- Stdout is captured to the cron log; write human-readable status lines throughout.
- Do not prompt for input — this runs headless. If a bump requires human sign-off, record it in `versions.md` and move on.
- The cron job itself lives in `~/.hermes/cron/` and calls `claude -p "run the daily update check"` from `/Users/mkyed/src/just-rails-8`.

## Verification that the skill is working

After the first cron run, expect a commit like:

```
chore(deps): bump maglevcms 3.0.0 → 3.0.1
```

if an eligible bump was found, or a clean working tree with a short `versions.md` artifact otherwise.
