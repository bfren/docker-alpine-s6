# Docker Alpine + S6

![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/bcgdesign/alpine-s6/latest?label=latest) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/bencgreen/docker-alpine-s6/build?label=github) ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/bcgdesign/alpine-s6?label=docker) ![Docker Pulls](https://img.shields.io/docker/pulls/bcgdesign/alpine-s6?label=pulls) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/bcgdesign/alpine-s6/latest?label=size)

[Docker Repository](https://hub.docker.com/r/bcgdesign/alpine-s6])

I've been using [webhippie](https://github.com/dockhippie/alpine)'s Alpine image for a while, but I wanted to control the Alpine and S6 versions.

Cron is enabled by default - include jobs in `/etc/periodic/*` or overlay `/etc/crontabs/root`.

## Packages

The image comes as base Alpine plus the `tzdata` package pre-installed.

## Authors

* [Ben Green](https://github.com/bencgreen)
* [Thomas Boerger](https://github.com/tboerger)

## License

> MIT

## Copyright

> Copyright (c) 2020 Ben Green <https://bcgdesign.com>  
> Unless otherwise stated
