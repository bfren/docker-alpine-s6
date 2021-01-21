# Docker Alpine + S6

![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/bcgdesign/alpine-s6/latest?label=latest) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/bencgreen/docker-alpine-s6/build?label=github) ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/bcgdesign/alpine-s6?label=docker) ![Docker Pulls](https://img.shields.io/docker/pulls/bcgdesign/alpine-s6?label=pulls) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/bcgdesign/alpine-s6/latest?label=size)

[Docker Repository](https://hub.docker.com/r/bcgdesign/alpine-s6) - [bcg|design ecosystem](https://github.com/bencgreen/docker)

The image comes with an [S6 overlay](https://github.com/just-containers/s6-overlay) pre-installed - currently version 2.2.0.0.

Cron is enabled by default - include jobs in `/etc/periodic/*` or overlay `/etc/crontabs/root`.

## apk Repositories

Edge repositories are added using tags, so only stable packages are installed/upgraded by default, but edge ones can be used like so: `apk add curl@edgemain`.

```bash
@edgemain # Edge main packages
@edgecomm # Edge community packages
```

## Helper Functions

Function | Arguments                 | Description
-------- | ------------------------- | -----------
`_c`     | 1: ANSI colour<br>2: Text | Echoes `$2` to `stdout` in `$1` with prefix:<br>`[bcg] %Y-%m-%d %H:%M:%S`
`_echo`  | 1: Text                   | Echoes `$1` to `stdout` in black with prefix
`_done`  | *None*                    | Echoes 'done.' to `stdout` in green with prefix
`_ok`    | *None*                    | Echoes 'ok.' to `stdout` in green with prefix
`_error` | 1: Text                   | Echoes `$1` to `stdout` in red with prefix
`_rmrf`  | 1: Path                   | Runs `rm -rf $1` safely: doing nothing if `$1` is empty

## Authors

* [Ben Green](https://github.com/bencgreen)

## License

> MIT

## Copyright

> Copyright (c) 2021 Ben Green <https://bcgdesign.com>  
> Unless otherwise stated
