# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.1.0] - 2026-02-19

### Changed

- Updated Node.js to 22 LTS for Maglev flavor
- Updated Maglev HyperUI Kit to 1.3
- Improved full reset script

### Fixed

- RDoc warnings and Yarn installation for Maglev setup
- Vite build failure and Rails conflict prompts
- Maglev setup warnings and duplicate gem error

## [2.0.0] - 2026-01-06

### Changed

- Upgraded to Ruby 4.0 and Rails 8.1
- Upgraded MaglevCMS to 2.1.0 (official SQLite3 support)
- Improved project discoverability metadata

### Fixed

- README.md now preserved during Rails setup

## [1.2.0] - 2025-07-18

### Changed

- Upgraded MaglevCMS to 2.0.0 with SQLite3 support
- Simplified reset script — removed hard-coded Rails file list, uses git-based cleanup
- Enhanced project documentation

### Fixed

- .gitignore restored properly after reset
- README.md no longer overwritten by Rails generator residue
- .claude folder removed from git tracking

## [1.1.0] - 2025-05-05

### Changed

- Simplified setup and configuration — thanks to @henrikbjorn

## [1.0.1] - 2025-04-30

### Added

- Maglev CMS as second flavor (`JR8_FLAVOR=maglev`)

## [1.0.0] - 2025-04-28

### Added

- Initial release
- Containerized Rails 8 development environment with Docker Compose
- Vanilla Rails 8 with SQLite flavor
- Setup script for automatic Rails app generation
- Reset script for environment cleanup
- Database migration runs automatically on setup

[Unreleased]: https://github.com/mkyed/just-rails-8/compare/v2.1.0...HEAD
[2.1.0]: https://github.com/mkyed/just-rails-8/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/mkyed/just-rails-8/compare/v1.2.0...v2.0.0
[1.2.0]: https://github.com/mkyed/just-rails-8/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/mkyed/just-rails-8/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/mkyed/just-rails-8/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/mkyed/just-rails-8/releases/tag/v1.0.0
