FROM --platform=$BUILDPLATFORM golang:alpine AS build

ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN echo "Build: $BUILDPLATFORM, target: $TARGETPLATFORM" > /log

FROM alpine:3.12.3
COPY --from=build /log /log

ARG TARGETPLATFORM

LABEL maintainer="Ben Green <ben@bcgdesign.com>" \
    org.label-schema.name="Alpine + S6" \
    org.label-schema.version="3.12" \
    org.label-schema.vendor="Ben Green" \
    org.label-schema.schema-version="1.0"

COPY ./overlay /
COPY ./3.12/repositories /etc/apk/repositories

ARG S6_VERSION=2.2.0.1
RUN chmod +x /tmp/install /usr/local/bin/bcg-* \
    && /tmp/install \
    && rm -rf /tmp/* \
    && chmod a=rwx,u+t /tmp

ENV \
    # cron log levels are from 0 (most verbose) to 8 (default)
    CRON_LOG_LEVEL=8 \
    # include hidden files and directories when fix-attrs.d processes them
    S6_FIX_ATTRS_HIDDEN=1

ENTRYPOINT [ "/init" ]
