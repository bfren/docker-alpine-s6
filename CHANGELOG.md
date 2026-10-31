# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [7.0.0] - Unreleased

### Changed

- Base image updated to `bfren/alpine` 4.0.0 - see the
  [Alpine changelog](https://github.com/bfren/docker-alpine/blob/main/CHANGELOG.md).
- Images are built and published by the shared `bfren/docker` build workflow (`build.yml`), replacing the separate
  `dev.yml` and `publish.yml` workflows.

### Removed

- **Breaking:** images for Alpine 3.15, 3.16, 3.17, 3.18 and 3.19 are no longer built. Supported versions are now
  Alpine 3.20 to 3.24.

[7.0.0]: https://github.com/bfren/docker-alpine-s6/compare/v6.7.3...v7.0.0
