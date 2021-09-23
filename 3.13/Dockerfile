FROM --platform=$BUILDPLATFORM golang:alpine AS build

ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN echo "Build: $BUILDPLATFORM, target: $TARGETPLATFORM" > /log

FROM alpine:3.13.6
COPY --from=build /log /log

ARG TARGETPLATFORM

ENV \
    # set to 0 to disable additional log output
    BF_DEBUG=1 \
    # cron log levels are from 0 (most verbose) to 8 (default)
    BF_CRON_LOG_LEVEL=8 \
    # include hidden files and directories when fix-attrs.d processes them
    S6_FIX_ATTRS_HIDDEN=1

COPY ./overlay /
COPY ./3.13/repositories /etc/apk/repositories

RUN chmod +x /usr/local/bin/bf-*
RUN bf-install

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=5 CMD [ "healthcheck" ]

ENTRYPOINT [ "/bf-init" ]
