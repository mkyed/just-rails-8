# JustRails8

[![Ruby](https://img.shields.io/badge/Ruby-4.0-red.svg)](https://www.ruby-lang.org/)
[![Rails](https://img.shields.io/badge/Rails-8.1-red.svg)](https://rubyonrails.org/)
[![Docker](https://img.shields.io/badge/Docker-Compose-blue.svg)](https://docs.docker.com/compose/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A minimal **Rails 8 starter template** with Docker Compose. Get a fully working Rails 8 development environment in seconds. Supports vanilla Rails or [MaglevCMS](https://www.maglev.dev/) for content management.

## Quick Start

```bash
git clone https://github.com/mkyed/just-rails-8 my-project
cd my-project
docker compose up
```

Open http://localhost:3008 - done!

## Features

- **Zero Configuration** - Just `docker compose up` and start coding
- **Ruby 4.0 + Rails 8.1** - Latest stable versions
- **Two Flavors**:
  - **Vanilla**: Minimal Rails 8 with SQLite
  - **Maglev CMS**: Rails 8 with [MaglevCMS 2.1](https://www.maglev.dev/) website builder
- **Local Editing** - Files mounted as volumes, edit with your favorite IDE
- **Persistent Data** - Database and gems cached between restarts

## Usage

### Vanilla Rails 8

```bash
docker compose up
```

### With MaglevCMS

```bash
JR8_FLAVOR=maglev docker compose up
```

### Reset Environment

```bash
./just-rails-8/reset.sh --clean-untracked
```

## Using as a Template

JustRails8 is designed as a starting point for new projects:

1. Clone or use GitHub's "Use this template" button
2. Reset Git history to start fresh:
   ```bash
   rm -rf .git
   git init
   git add .
   git commit -m "Initial commit"
   ```
3. Push to your own repository

## Project Structure

```
.
├── docker-compose.yml      # Docker Compose configuration
├── just-rails-8/
│   ├── Dockerfile          # Ruby 4.0 image with Rails 8.1
│   ├── setup.sh            # Initializes Rails app on first run
│   └── reset.sh            # Cleanup script
└── (Rails app files generated on first run)
```

## Configuration

| Setting | Default | Description |
|---------|---------|-------------|
| Port | 3008 | Host port (maps to container 3000) |
| Database | SQLite | Persistent via Docker volume |
| `JR8_FLAVOR` | vanilla | Set to `maglev` for CMS |

## Requirements

- [Docker](https://docs.docker.com/get-docker/) with Docker Compose
- [Git](https://git-scm.com/)

## Common Commands

```bash
# Start app
docker compose up

# Rebuild after Dockerfile changes
docker compose up --build

# Rails console
docker compose exec web rails console

# Run migrations
docker compose exec web rails db:migrate

# Stop containers
docker compose down
```

## License

[MIT](LICENSE)
