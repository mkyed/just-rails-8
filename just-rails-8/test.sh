#!/bin/bash
#
# End-to-end test for both JustRails8 flavors.
# Builds from scratch and verifies each flavor serves a browsable website.
#
# Usage:
#   ./just-rails-8/test.sh              # test both flavors
#   ./just-rails-8/test.sh vanilla      # test vanilla only
#   ./just-rails-8/test.sh maglev       # test maglev only
#

set -euo pipefail

FLAVORS="${*:-vanilla maglev}"
TIMEOUT=480  # 8 minutes for initial build + boot

pass() { echo "  ✓ $1"; }
fail() { echo "  ✗ $1"; docker compose logs; exit 1; }

wait_for_http() {
  local deadline=$((SECONDS + TIMEOUT))
  while [ $SECONDS -lt $deadline ]; do
    if curl -sf http://localhost:3008 -o /dev/null 2>/dev/null; then
      return 0
    fi
    sleep 5
  done
  return 1
}

test_flavor() {
  local flavor=$1
  echo ""
  echo "=== Testing $flavor flavor ==="

  ./just-rails-8/reset.sh --clean-untracked

  JR8_FLAVOR=$flavor docker compose up -d

  echo "  Waiting for app (up to ${TIMEOUT}s)..."
  if wait_for_http; then
    pass "localhost:3008 is up"
  else
    fail "app never became available after ${TIMEOUT}s"
  fi

  STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3008)
  [ "$STATUS" = "200" ] && pass "root page returns HTTP 200" || fail "root page returned HTTP $STATUS"

  if [ "$flavor" = "maglev" ]; then
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" -L http://localhost:3008/maglev)
    { [ "$STATUS" = "200" ] || [ "$STATUS" = "302" ]; } \
      && pass "Maglev editor accessible (HTTP $STATUS)" \
      || fail "Maglev editor returned HTTP $STATUS"
  fi

  docker compose down -v
  ./just-rails-8/reset.sh --clean-untracked
  echo "=== $flavor: PASS ==="
}

for flavor in $FLAVORS; do
  test_flavor "$flavor"
done

echo ""
echo "All flavor tests passed."
