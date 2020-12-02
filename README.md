# Docker Alpine + S6

![Docker Image Version (latest semver)](https://img.shields.io/docker/v/bcgdesign/alpine-s6?sort=semver) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/bencgreen/docker-alpine-s6/build?label=github) ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/bcgdesign/alpine-s6?label=docker) ![Docker Pulls](https://img.shields.io/docker/pulls/bcgdesign/alpine-s6?label=pulls) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/bcgdesign/alpine-s6/latest?label=size)

[Docker Repository](https://hub.docker.com/r/bcgdesign/alpine-s6) - [bcg|design ecosystem](https://github.com/bencgreen/docker)

I've been using [webhippie](https://github.com/dockhippie/alpine)'s Alpine image for a while, but I wanted to control the Alpine and S6 versions.

Cron is enabled by default - include jobs in `/etc/periodic/*` or overlay `/etc/crontabs/root`.

## Packages

The image is the [base Alpine image](https://github.com/alpinelinux/docker-alpine) plus the `tzdata` package.

## Environment Variables

```bash
WITH_BASH=0 # set to 1 if you would like the bash shell to be installed automatically
```

## apk Repositories

Edge repositories are added using tags, so only stable packages are installed /upgraded by default, but the latest ones can be used like so: `apk add curl@edgemain`.

```bash
@edgemain # Edge main packages
@edgecomm # Edge community packages
```

## Authors

* [Ben Green](https://github.com/bencgreen)

## License

> MIT

## Copyright

> Copyright (c) 2020 Ben Green <https://bcgdesign.com>  
> Unless otherwise stated
