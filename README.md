# Docker Alpine + S6

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bencgreen/docker-alpine-s6) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/bencgreen/docker-alpine-s6/build?label=github) ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/bcgdesign/alpine-s6?label=docker) ![Docker Pulls](https://img.shields.io/docker/pulls/bcgdesign/alpine-s6?label=pulls) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/bcgdesign/alpine-s6/latest?label=size)

[Usage Guide](https://github.com/bencgreen/docker/wiki/alpine-s6) - [Docker Repository](https://hub.docker.com/r/bcgdesign/alpine-s6) - [bcg|design ecosystem](https://github.com/bencgreen/docker)

[Alpine](https://alpinelinux.org/)'s base image (version 3.12.3 and 3.13.1) with [S6 overlay](https://github.com/just-containers/s6-overlay) pre-installed (version 2.2.0.1).

Cron is enabled by default - include jobs in `/etc/periodic/*` or overlay `/etc/crontabs/root`.

## Contents

* [apk Repositories](#apk-repositories)
* [Helper Functions](#helper-functions)
* [Authors / Licence / Copyright](#authors)

## apk Repositories

Edge repositories are added using tags, so only stable packages are installed/upgraded by default, but edge ones can be used like so: `apk add curl@edgemain`.

```bash
@edgemain # Edge main packages
@edgecomm # Edge community packages
```

## Helper Functions

| Function     | Arguments                                      | Description                                                                                   |
| ------------ | ---------------------------------------------- | --------------------------------------------------------------------------------------------- |
| `_disable`   | 1: Service name                                | Uses S6 to disable the service named `$1`.                                                    |
| `_done`      | *None*                                         | Echoes 'done.' to `stdout` in green with prefix (see `_e`).                                   |
| `_e`         | 1: ANSI colour<br>2: Text                      | Echoes `$2` to `stdout` in `$1` with prefix:<br>`[bcg] %Y-%m-%d %H:%M:%S`.                    |
| `_echo`      | 1: Text                                        | Echoes `$1` to `stdout` in black with prefix (see `_e`).                                      |
| `_error`     | 1: Text                                        | Echoes `$1` to `stdout` in red with prefix (see `_e`).                                        |
| `_forward`   | 1: Service name<br>2: Path to error log file   | Forwards errors logged in `$2` to Docker logs - if `$2` is not set, disables service `$1`.    |
| `_notok`     | *None*                                         | Echoes `$1` to `stdout` in green with prefix (see `_e`).                                      |
| `_ok`        | *None*                                         | Echoes 'ok.' to `stdout` in red with prefix (see `_e`).                                       |
| `_rmrf`      | 1: Path                                        | Runs `rm -rf $1` safely: doing nothing if `$1` is empty.                                      |
| `_terminate` | *None*                                         | Terminates all running services - used in `finish` file of a service in `services.d`.         |
| `_tz`        | 1: Timezone                                    | Sets the container's timezone to `$1`.                                                        |

## Authors

* [Ben Green](https://github.com/bencgreen)

## License

> MIT

## Copyright

> Copyright (c) 2021 Ben Green <https://bcgdesign.com>
> Unless otherwise stated
