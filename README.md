# Docker Alpine + S6

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bencgreen/docker-alpine-s6) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/bencgreen/docker-alpine-s6/build?label=github) ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/bcgdesign/alpine-s6?label=docker) ![Docker Pulls](https://img.shields.io/docker/pulls/bcgdesign/alpine-s6?label=pulls) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/bcgdesign/alpine-s6/latest?label=size)

[Usage Guide](https://github.com/bencgreen/docker/wiki/alpine-s6) - [Docker Repository](https://hub.docker.com/r/bcgdesign/alpine-s6) - [bcg|design ecosystem](https://github.com/bencgreen/docker)

[Alpine](https://alpinelinux.org/)'s base image (v3.12.3 and v3.13.2) with [S6 overlay](https://github.com/just-containers/s6-overlay) pre-installed (version 2.2.0.3).

Cron is enabled by default - include jobs in `/etc/periodic/*` directories, or overlay `/etc/crontabs/root` (be warned this will override Alpine's default behaviour).

[esh](https://github.com/jirutka/esh) - a shell templating engine - comes preinstalled, and is used extensively in the [bcg|design Docker ecosystem](https://github.com/bencgreen/docker).

## Contents

* [apk Repositories](#apk-repositories)
* [Environment Variables](#environment-variables)
* [Helper Functions](#helper-functions)
* [Authors / Licence / Copyright](#authors)

## apk Repositories

Edge repositories are added using tags, so only stable packages are installed/upgraded by default, but edge ones can be used like so: `apk add curl@edgemain`.

```bash
@edgemain # Edge main packages
@edgecomm # Edge community packages
```

## Environment Variables

| Variable         | Values | Description                                      | Default |
| ---------------- | ------ | ------------------------------------------------ | ------- |
| `CRON_LOG_LEVEL` | 0-8    | Sets the cron log level (0 is the most verbose). | 8       |

## Helper Functions

### Output

| Function           | Arguments                                    | Description                                                                                |
| ------------------ | -------------------------------------------- | ------------------------------------------------------------------------------------------ |
| `bcg-debug`        | 1: Script / executable name<br>2: Text       | Echoes `$1: $2` to `stdout` in grey with prefix (see `bcg-e`).                             |
| `bcg-done`         | *None*                                       | Echoes 'done.' to `stdout` in green with prefix (see `bcg-e`).                             |
| `bcg-e`            | 1: Namespace<br>2: ANSI colour<br>3: Text    | Echoes `$3` to `stdout` in `$2` with prefix:<br>`[$1] %Y-%m-%d %H:%M:%S`.                  |
| `bcg-echo`         | 1: Text                                      | Echoes `$1` to `stdout` in black with prefix (see `bcg-e`).                                |
| `bcg-error`        | 1: Text                                      | Echoes `$1` to `stdout` in red with prefix (see `bcg-e`).                                  |
| `bcg-notok`        | *None*                                       | Echoes `$1` to `stdout` in green with prefix (see `bcg-e`).                                |
| `bcg-ok`           | *None*                                       | Echoes 'ok.' to `stdout` in red with prefix (see `bcg-e`).                                 |

### Other

| Function            | Arguments                                                                                      | Description                                                                                 |
| ------------------- | ---------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| `bcg-adduser`       | 1: Group &amp; user name<br>2: GID (optional, default 1000)<br>3: UID (optional, default 1000) | Create group with id `$2`, user with id `$3`, both with name `$1`, and no home or password. |
| `bcg-clear`         | *None*                                                                                         | Clears contents of `/tmp`/ and `apk` cache.                                                 |
| `bcg-env`           | 1: Name of environment variable<br>2: Value of environment variable                            | Adds a container environment variable called `$1` with value `$2`.                          |
| `bcg-fix-attrs`     | *None*                                                                                         | Re-applies attributes and permissions defined in `fix-attrs.d`.                             |
| `bcg-forward`       | 1: Service name<br>2: Path to error log file                                                   | Forwards errors logged in `$2` to Docker logs - if `$2` is not set, disables service `$1`.  |
| `bcg-install`       | *None*                                                                                         | Runs `/tmp/install` - if it doesn't exist, throws an error.                                 |
| `bcg-rmrf`          | 1: Path                                                                                        | Runs `rm -rf $1` safely: doing nothing if `$1` is empty.                                    |
| `bcg-rnd`           | 1: Number of characters                                                                        | Generates a string of random letters and numbers of length `$1`.                            |
| `bcg-svc`           | 1: Control action 'disable', 'restart', 'start', or 'stop'<br>2: Service name                  | Uses S6 to control the service named `$2`.                                                  |
| `bcg-svc-terminate` | *None*                                                                                         | Terminates all running services - used in `finish` file of a service in `services.d`.       |
| `bcg-tz`            | 1: Timezone                                                                                    | Sets the container's timezone to `$1`.                                                      |

## Authors

* [Ben Green](https://github.com/bencgreen)

## License

> MIT

## Copyright

> Copyright (c) 2021 Ben Green <https://bcgdesign.com>
> Unless otherwise stated
