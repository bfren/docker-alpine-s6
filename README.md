# Alpine + S6

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bfren/docker-alpine-s6) ![Docker Pulls](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fpulls%2Falpine-s6) ![Docker Image Size](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fsize%2Falpine-s6) ![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/bfren/docker-alpine-s6/dev.yml?branch=main)

[Docker Hub](https://hub.docker.com/r/bfren/alpine-s6) - [Quay.io](https://quay.io/repository/bfren/alpine-s6) - [bfren ecosystem](https://github.com/bfren/docker)

## Introduction

This is the base image for the long-running services in the [bfren ecosystem](https://github.com/bfren/docker) - nginx, MariaDB, PostgreSQL, Redis and others are all built on it. It is built on [Alpine](https://github.com/bfren/docker-alpine), so everything in that image is available here too.

It is [Alpine Linux](https://alpinelinux.org) with:

* the [S6 Overlay](https://github.com/just-containers/s6-overlay) process supervisor, so one container can run a service *and* the jobs around it (cron, log forwarding, start-up checks)
* [Nushell](https://www.nushell.sh) with the `bf` and `bf-s6` modules, for writing start-up scripts and helpers
* a standard layout for initialisation, permissions, templates and scheduled tasks

You probably don't want to run this image on its own. Use it as the `FROM` line for your own image. For images that run a single command or tool, use [Alpine](https://github.com/bfren/docker-alpine) instead.

## Quickstart

A minimal image that runs one supervised service:

```plain
my-image/
├── Dockerfile
└── overlay/
    └── etc/s6-overlay/
        ├── s6-rc.d/myapp/
        │   ├── dependencies.d/init     (empty file)
        │   ├── type                    (contains: longrun)
        │   ├── run
        │   └── finish
        └── user-bundles.d/user/contents.d/myapp   (empty file)
```

`Dockerfile`:

```dockerfile
FROM quay.io/bfren/alpine-s6:alpine3.24-6.7

ARG BF_IMAGE=my-image
ARG BF_VERSION=1.0.0

COPY ./overlay /
RUN apk add --no-cache myapp && bf-install
```

`run` - start your service in the foreground, **ending with `bf-s6 svc launch`**:

```nu
#!/usr/bin/nu

use bf
use bf-s6
bf env load

# Start myapp in the foreground so it can be supervised by S6
def main [
    name: string    # The service name, passed by s6-supervise
] {
    # set executable name - used to make log output more useful
    bf env x_set --override run $name

    # run checks before executing service
    bf write debug "No pre-run checks required."

    # flags:
    #   --foreground  stay in the foreground (allows S6 to supervise the service)
    bf write "Starting myapp."
    let args = [
        "--foreground"
    ]
    bf-s6 svc launch myapp ...$args
}
```

`finish` - pass S6's arguments through so the container only stops if `myapp` fails:

```nu
#!/usr/bin/nu

use bf
use bf-s6
bf env load -x myapp

# Show helpful log message
def main [...args] { bf-s6 svc finish --terminate ...$args }
```

Build it, run it, and check `myapp` is supervised directly by S6:

```sh
docker build -t my-image . && docker run -d --name test my-image
docker exec test ps -o pid,ppid,args
```

`myapp`'s parent should be `s6-supervise myapp`. If `nu` or a shell is in between, the `run` script is not ending with `bf-s6 svc launch`.

## Features

* 🐧 Alpine 3.15 to 3.24 - choose with the image tag
* 🧭 S6 Overlay process supervision, with clean shutdown on `docker stop`
* 🚀 Nushell start-up scripts in `/etc/bf/init.d`, run in order before any service starts
* 🔐 Permissions applied from simple text files in `/etc/bf/ch.d`
* 🩺 Health checks from every image in the chain, added as scripts in `/etc/bf/health.d`
* 📝 Configuration files generated from [esh](https://github.com/jirutka/esh) templates in `/etc/bf/templates`
* ⏰ Cron, with folders for jobs every minute, 15 minutes, hour, day, week and month
* 🕐 Timezone set from `BF_TZ` during start-up
* 🛑 The container stops if a service fails - but not when you restart a service on purpose, or on `docker stop`
* 🩺 A `HEALTHCHECK` that checks cron is running, which you can override with your own script
* 🧪 Built-in test runner and smoke test

## Tags

Images are published to Docker Hub (`bfren/alpine-s6`) and Quay.io (`quay.io/bfren/alpine-s6`) for `linux/amd64`, `linux/arm/v7` and `linux/arm64`.

| Tag                           | Example              | Use when                                              |
| ----------------------------- | -------------------- | ----------------------------------------------------- |
| `alpineX.Y`                   | `alpine3.24`         | You want the latest image for an Alpine version       |
| `alpineX.Y-MAJOR`             | `alpine3.24-6`       | You want updates, but not breaking changes            |
| `alpineX.Y-MINOR`             | `alpine3.24-6.7`     | You want fixes only - **recommended for building on** |
| `alpineX.Y-VERSION`           | `alpine3.24-6.7.0`   | You want to pin this image exactly                    |
| `alpineX.Y.Z`                 | `alpine3.24.2`       | You want an exact Alpine release                      |
| `alpineX.Y.Z-VERSION`         | `alpine3.24.2-6.7.0` | You want to pin both                                  |
| `latest`, `6`, `6.7`, `6.7.0` |                      | As above, on the newest Alpine version                |

| Alpine | Security support ends |
| ------ | --------------------- |
| 3.24   | 2028-06-01            |
| 3.23   | 2027-11-01            |
| 3.22   | 2027-05-01            |
| 3.21   | 2026-11-01            |
| 3.20   | ended 2026-04-01      |
| 3.19   | ended 2025-11-01      |
| 3.18   | ended 2025-05-09      |
| 3.17   | ended 2024-11-22      |
| 3.16   | ended 2024-05-23      |
| 3.15   | ended 2023-11-01      |

Images for unsupported Alpine versions are still built, but no longer receive Alpine security fixes - avoid them for anything new.

## Configuration

### Environment Variables

| Variable            | Values     | Description                                                 | Default         |
| ------------------- | ---------- | ----------------------------------------------------------- | --------------- |
| `BF_DEBUG`          | `0`, `1`   | Show detailed output from `bf` scripts.                     | `0`             |
| `BF_TZ`             | timezone   | Container timezone, e.g. `Europe/London`.                   | `Europe/London` |
| `BF_CRON_LOG_LEVEL` | `0` to `8` | Cron log detail - `0` is the most verbose.                  | `8`             |
| `BF_ENABLE_INIT_CH` | `0`, `1`   | Set to `0` to skip applying `ch.d` permissions at start-up. | `1`             |

### Build Arguments

| Argument        | Description                                                                   |
| --------------- | ----------------------------------------------------------------------------- |
| `BF_IMAGE`      | **Required by `bf-install`.** The image name, saved to `/etc/bf/IMAGE`.       |
| `BF_VERSION`    | **Required by `bf-install`.** The image version, saved to `/etc/bf/VERSION`.  |
| `BF_PUBLISHING` | Set to `1` for release builds - removes the test files and preinstall script. |

## How It Works

### Starting

S6 is the entrypoint. When the container starts:

1. **Initialisation** - the `init` service runs `bf-init`, which saves the container's environment (including anything you pass with `-e`) to `/etc/bf/env.d`, then runs every `*.nu` file in `/etc/bf/init.d` in natural sort order. If any of them fails, the container stops.
2. **Services** - S6 starts each service listed in `user-bundles.d/user/contents.d`, once its dependencies (normally `init`) have finished.
3. **Running** - S6 supervises each service. If one exits, its `finish` script decides whether to stop the container (see [When does the container stop?](#when-does-the-container-stop)).

### Initialisation scripts

The image includes these, so start yours at `10` or above:

| Script          | Does                                                               |
| --------------- | ------------------------------------------------------------------ |
| `00-welcome.nu` | Shows the image name and version                                   |
| `01-env.nu`     | Sets the standard `BF_` variables (image, directories, cron paths) |
| `02-ch.nu`      | Applies the permissions files in `/etc/bf/ch.d`                    |
| `03-tz.nu`      | Sets the timezone from `BF_TZ`                                     |
| `04-cron.nu`    | Generates the default crontab                                      |

Add your own, for example:

```nu
# /etc/bf/init.d/10-myapp.nu
use bf
use bf-s6
bf env load

def main [] {
    bf env set MYAPP_DATA "/data"       # saved as BF_MYAPP_DATA for every later script
    bf-s6 esh template "/etc/myapp/myapp.conf"
}
```

Variables set with `bf env set` are saved to `/etc/bf/env.d`, so services and cron jobs can read them.

### Environment

`bf env load` loads the variables saved in `/etc/bf/env.d`, so every script sees the same values. Shell scripts can do the same by starting with `#!/bin/withenv sh`, which runs them with a *clean* environment loaded from `/etc/bf/env.d`. Read the [Alpine base image documentation](https://github.com/bfren/docker-alpine#environment) for more.

### Service scripts

S6 runs each service's `run` script with one argument - the service name - so `main` must accept it (see the [Quickstart](#quickstart)). End the script with `bf-s6 svc launch`, which:

* replaces the `run` script with your service, so S6 supervises it directly and signals (including `docker stop`) reach it
* passes every argument through unchanged - build them as a list, one flag per line, and spread it with `...$args`
* hides Nushell's own variables (`NU_VERSION`, `CURRENT_FILE`, etc.) from your service

Do any checks before the launch. To stop a service starting - for example if an optional feature is turned off - call `bf-s6 svc down $name` and `return`, rather than exiting, otherwise S6 will just run the script again.

### Permissions (`ch.d`)

Each line of a file in `/etc/bf/ch.d` is `path owner [file-mode] [directory-mode]`:

```plain
/etc/myapp  myapp:myapp  0400  0500
/data       myapp:myapp
```

Ownership is applied recursively; modes are applied to files and directories separately. Files are applied in order at start-up, and you can apply one at any time with `bf-s6 ch apply_file 10-myapp`.

### Templates

Put `myapp.conf.esh` in `/etc/bf/templates`, then generate `/etc/myapp/myapp.conf` with:

```nu
bf-s6 esh template "/etc/myapp/myapp.conf"
```

The template is found by the output file's name, and the output folder must already exist.

### Scheduled tasks

Put an executable script in one of these folders and it will run on that schedule:

| Folder                  | Runs               |
| ----------------------- | ------------------ |
| `/etc/periodic/1min`    | every minute       |
| `/etc/periodic/15min`   | every 15 minutes   |
| `/etc/periodic/hourly`  | on the hour        |
| `/etc/periodic/daily`   | 02:00              |
| `/etc/periodic/weekly`  | 03:00 on Saturdays |
| `/etc/periodic/monthly` | 05:00 on the 1st   |

To generate a script in one of those folders from a template, use `bf-s6 crontab generate_template hourly myjob`. For anything else, add a line to the crontab from an initialisation script:

```nu
bf-s6 crontab add "my-command" --min "*/5" --hour "9-17"
```

### When does the container stop?

S6 calls each service's `finish` script with the service's exit code and signal. With `bf-s6 svc finish --terminate`:

| How the service stopped                                   | Container                               |
| --------------------------------------------------------- | --------------------------------------- |
| Exited cleanly (code 0)                                   | keeps running - S6 restarts the service |
| Stopped by `SIGTERM` (`bf-s6 svc restart`, `docker stop`) | keeps running / shuts down normally     |
| Killed by any other signal (`SIGKILL`, crash)             | **stops**                               |
| Exited with an error                                      | **stops**                               |

To restart a service without stopping the container:

```nu
bf-s6 svc restart myapp
```

If your service shuts down gracefully with a signal other than `SIGTERM` (PostgreSQL uses `SIGINT`), put that signal's name in a `down-signal` file in the service directory.

### Health checks

The image runs `bf-healthcheck` every 30 seconds (every 2 seconds during the first 60 seconds, so a new container reports healthy quickly). It runs every `*.nu` file in `/etc/bf/health.d`, and the container is healthy only if they all pass. This image adds `00-cron.nu`, which checks that the cron service is running.

To check your own service, add a script to `/etc/bf/health.d` - numbered like your `init.d` scripts, e.g. `10-myapp.nu` - that fails (with `exit 1` or `bf write error`) when the service is unhealthy - don't replace `bf-healthcheck`. Checks from every image in the chain run together, so an image built on Nginx keeps Nginx's check as well as adding its own. Failed checks and their output appear in `docker inspect --format '{{json .State.Health}}' <container>`.

```nu
# /etc/bf/health.d/10-myapp.nu
use bf
bf env load -x

def main [] { "http://localhost:8080" | bf http test | if not $in { exit 1 } }
```

### The `bf-s6` module

This module is added to the `bf` module from [Alpine](https://github.com/bfren/docker-alpine#the-bf-module). Load it with `use bf-s6`.

| Submodule       | Use                                                                         |
| --------------- | --------------------------------------------------------------------------- |
| `bf-s6 ch`      | Apply the ownership and permissions in a `ch.d` file                        |
| `bf-s6 cont`    | Terminate the container                                                     |
| `bf-s6 crontab` | Add lines to the crontab, and generate cron scripts from templates          |
| `bf-s6 esh`     | Generate a file from an esh template, found by the output file's name       |
| `bf-s6 health`  | Run the checks in `/etc/bf/health.d` (used by `bf-healthcheck`)        |
| `bf-s6 init`    | Run the scripts in `/etc/bf/init.d` (used by `bf-init`)                     |
| `bf-s6 log`     | Tail a log file and forward it to the container's output                    |
| `bf-s6 svc`     | Launch, restart, stop and check services, and handle their `finish` scripts |

Run `help bf-s6 <submodule>` in a `nu` shell for details.

A few have executable helpers on the `PATH`: `bf-init`, `bf-cron`, `bf-cont-terminate` and `bf-healthcheck`. Check out `overlay/usr/bin/bf` for the complete list.

## Testing

* `/test` runs the Nushell tests in `/etc/nu/scripts/tests` (add yours to `tests/mod.nu`). Before running, it checks that tests really execute and fails if they don't. Tests are removed from published images, so run them on your own builds.
* `./smoke.sh <image>` starts the image normally and checks that services start, are supervised directly by S6, survive a restart, and stop the container when killed.

```sh
./test.nu        # builds the image, then runs /test and the smoke test
./test.nu --all  # every version, in parallel
```

## Troubleshooting

### A service's parent process is `nu` or a shell, not `s6-supervise`

The `run` script is not ending with `bf-s6 svc launch`, or a wrapper it calls is missing `exec`. Signals from S6 then reach the wrapper instead of your service.

### The `run` script fails with "extra positional argument"

S6 passes the service name to `run`, so `main` must accept it - use `def main [name: string]`, not `def main []`.

### The container stops when I restart a service

Check the service's `finish` script passes `...$args` to `bf-s6 svc finish`. Without them, the finish script can't tell a deliberate restart from a crash, so it stops the container to be safe.

### The container stops during start-up

An initialisation script failed. Run with `BF_DEBUG=1` and check `docker logs` - the failing script is named in the output.

### `/test` says the tests directory does not exist

Published images have their tests removed. Build the image yourself without `BF_PUBLISHING=1`.

## FAQs

### Should I use this image or Alpine?

Use this one for long-running services, especially if they need scheduled tasks or start-up checks. Use [Alpine](https://github.com/bfren/docker-alpine) for images that run a single command - a CLI tool, a build step, PHP scripts.

### Why S6 rather than one process per container?

Most real services need a few things alongside them - scheduled tasks, log forwarding, a configuration step before start-up. S6 runs these reliably in one container and shuts them all down cleanly.

### Why does the container stop when a service fails?

A failing service usually means a real problem. Stopping the container makes it obvious in `docker ps` and lets Docker's restart policy start again from a clean state, rather than S6 quietly restarting it forever.

### Why Nushell?

Structured data, real error handling and modules make start-up scripts much easier to read and test than shell scripts - while still being small enough for an Alpine image.

## Licence

> [MIT](https://mit.bfren.dev/2020)

## Copyright

> Copyright (c) 2020-2026 [bfren](https://bfren.dev) (unless otherwise stated)
