FROM --platform=$BUILDPLATFORM golang:alpine AS build

ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN echo "Build: $BUILDPLATFORM, target: $TARGETPLATFORM" > /log

FROM alpine:3.13.1
COPY --from=build /log /log

ARG TARGETPLATFORM

LABEL maintainer="Ben Green <ben@bcgdesign.com>" \
    org.label-schema.name="Alpine + S6" \
    org.label-schema.version="latest" \
    org.label-schema.vendor="Ben Green" \
    org.label-schema.schema-version="1.0"

ARG \
    # change to a valid timezone
    TZ=Europe/London

RUN apk -U upgrade \
    && apk add --virtual .tz tzdata \
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && apk del .tz \
    && rm -rf /var/cache/apk/*

COPY ./overlay /

ARG S6_VERSION=2.2.0.1
RUN chmod +x /tmp/install /usr/local/bin/_* \
    && /tmp/install \
    && rm -rf /tmp/* \
    && chmod a=rwx,u+t /tmp

ENTRYPOINT [ "/init" ]
