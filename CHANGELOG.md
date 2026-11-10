# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [7.0.2] - 2026-11-10

### Changed

- Base image updated to `bfren/alpine` 4.0.2, which updates Nushell to 0.117.0 - your own Nushell scripts may need
  changes - see the [Alpine changelog](https://github.com/bfren/docker-alpine/blob/main/CHANGELOG.md).
- `bf-s6 svc launch` no longer hides `CURRENT_FILE` and `FILE_PWD` from your service, because Nushell 0.117 refuses
  to hide them. It still hides `BF_X`, `LAST_EXIT_CODE`, `NU_VERSION` and `PROCESS_PATH`.

### Fixed

- The container no longer stops at start-up when `BF_TZ` cannot be set (setting it installs tzdata, so it needs
  network access, and the timezone must exist). It logs a warning and keeps the current timezone instead.

## [7.0.1] - 2026-11-06

### Changed

- Base image updated to `bfren/alpine` 4.0.1, which moves to Alpine 3.21.10, 3.22.8, 3.23.8 and 3.24.4 (with
  security fixes) and rebuilds BusyBox, figlet and Nushell - see the
  [Alpine changelog](https://github.com/bfren/docker-alpine/blob/main/CHANGELOG.md).

### Deprecated

- Alpine 3.21 reached the end of its support on 2026-11-01. Its images are still built, but no longer receive Alpine
  security fixes - avoid them for anything new.

## [7.0.0] - 2026-11-05

### Changed

- Base image updated to `bfren/alpine` 4.0.0 - see the
  [Alpine changelog](https://github.com/bfren/docker-alpine/blob/main/CHANGELOG.md).
- Images are built and published by the shared `bfren/docker` build workflow (`build.yml`), replacing the separate
  `dev.yml` and `publish.yml` workflows.

### Removed

- **Breaking:** images for Alpine 3.15, 3.16, 3.17, 3.18 and 3.19 are no longer built. Supported versions are now
  Alpine 3.20 to 3.24.

[7.0.2]: https://github.com/bfren/docker-alpine-s6/compare/v7.0.1...v7.0.2
[7.0.1]: https://github.com/bfren/docker-alpine-s6/compare/v7.0.0...v7.0.1
[7.0.0]: https://github.com/bfren/docker-alpine-s6/compare/v6.7.3...v7.0.0
