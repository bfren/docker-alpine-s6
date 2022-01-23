FROM --platform=$BUILDPLATFORM golang:alpine AS build

ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN echo "Build: $BUILDPLATFORM, target: $TARGETPLATFORM" > /log

FROM bfren/alpine:alpine3.14.3-1.3.3
COPY --from=build /log /log

ARG TARGETPLATFORM

ARG BF_IMAGE
ARG BF_VERSION

ENV \
    # cron log levels are from 0 (most verbose) to 8 (default)
    BF_CRON_LOG_LEVEL=8 \
    # include hidden files and directories when fix-attrs.d processes them
    S6_FIX_ATTRS_HIDDEN=1

COPY ./overlay /

RUN bf-install

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=5 CMD [ "healthcheck" ]

ENTRYPOINT [ "/init" ]
