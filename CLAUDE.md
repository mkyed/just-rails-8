# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

JustRails8 is a Rails 8 development template that provides a containerized Rails environment with Docker Compose. The project supports two flavors:

- **Vanilla**: Minimal Rails 8 app with SQLite
- **Maglev CMS**: Rails 8 with integrated Maglev CMS for content management

## Project Structure

The project uses a containerized approach where the actual Rails application is generated inside the Docker container:

- `docker-compose.yml`: Main Docker Compose configuration
- `just-rails-8/`: Contains setup files for the containerized environment
  - `Dockerfile`: Ruby 4.0 image with Rails 8.1 and dependencies
  - `setup.sh`: Initializes new Rails app or starts existing one
  - `reset.sh`: Cleans Docker resources and removes untracked files

## Common Commands

### Development Environment
```bash
# Start vanilla Rails 8 app
docker compose up

# Start with Maglev CMS
JR8_FLAVOR=maglev docker compose up

# Build with fresh image
docker compose up --build

# Stop containers
docker compose down
```

### Reset Environment
```bash
# Clean Docker resources only
./just-rails-8/reset.sh

# Clean Docker resources with verbose output
./just-rails-8/reset.sh --verbose

# Clean Docker resources AND remove all untracked files
./just-rails-8/reset.sh --clean-untracked --verbose
```

### Inside Container (once Rails app is generated)
```bash
# Standard Rails commands (run via docker compose exec)
docker compose exec web rails console
docker compose exec web rails db:migrate
docker compose exec web rails generate model User
docker compose exec web rails test
docker compose exec web bundle install
```

## Architecture Notes

- **Template Repository**: This is designed as a project template, not a library
- **Containerized Development**: Rails runs in Docker, files are volume-mounted for local editing
- **Port Mapping**: App runs on port 3008 (mapped from container port 3000)
- **Database**: SQLite with persistent volume (`db_data`)
- **Bundle Cache**: Gems cached in `bundle` volume for faster rebuilds
- **Environment Variables**: 
  - `RAILS_ENV=development`
  - `JR8_FLAVOR` (vanilla|maglev)

## Development Workflow

1. The Rails application is generated on first run by `setup.sh`
2. Local files are mounted to `/app` in the container
3. Changes to Ruby files are reflected immediately
4. Database persists between container restarts
5. Use `reset.sh` to clean environment when needed

## Setup Process

### Vanilla Setup
- Creates new Rails app with SQLite
- Skips Action Cable
- Runs `rails db:setup`

### Maglev Setup  
- Installs Node.js and Yarn
- Creates Rails app with SQLite
- Adds MaglevCMS 2.1.0 (latest stable version with SQLite3 support)
- Adds Maglev HyperUI Kit
- Installs Active Storage and image processing
- Runs Maglev generators and site creation

## Important Notes

- **MaglevCMS Version**: Updated to use version 2.1.0 (latest stable) with official SQLite3 support
- **Database Compatibility**: MaglevCMS 2.1.0 officially supports SQLite3 as an alternative to PostgreSQL
- **Volume Management**: When switching between flavors, clean the environment with `reset.sh` to avoid gem conflicts
- **Generated Files**: The Rails app is generated in the project root and persisted via volume mounts
- **Reset Script**: Use `--clean-untracked` flag to remove all untracked files including Rails residue

## Testing

Since this is a template project, testing commands depend on the generated Rails application. Standard Rails testing would apply once the app is created.

## Reset Script Usage

The `reset.sh` script provides comprehensive cleanup:

- **Basic Reset**: `./just-rails-8/reset.sh` - Cleans Docker resources and Rails files
- **Full Reset**: `./just-rails-8/reset.sh --clean-untracked` - Removes all untracked files
- **Verbose Mode**: Add `--verbose` to see detailed output
- **Help**: `./just-rails-8/reset.sh --help` for usage information

The script automatically:
- Reverts README.md if overwritten by Rails
- Removes common Rails-generated files
- Cleans Docker containers, volumes, and images
- Optionally removes all untracked files with `--clean-untracked`