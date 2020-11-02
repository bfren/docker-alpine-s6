FROM --platform=$BUILDPLATFORM golang:alpine AS build

ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN echo "Build: $BUILDPLATFORM, target: $TARGETPLATFORM" > /log

FROM alpine:3.12.1
COPY --from=build /log /log

LABEL maintainer="Ben Green <ben@bcgdesign.com>" \
    org.label-schema.name="Alpine" \
    org.label-schema.version="latest" \
    org.label-schema.vendor="Ben Green" \
    org.label-schema.schema-version="1.0"

RUN apk update && \
    apk upgrade && \
    apk add bash tzdata && \
    rm -rf /var/cache/apk/*

ARG TARGETPLATFORM
ENV S6_VERSION=2.1.0.2

COPY ./install /etc/install
RUN apk add --no-cache --virtual .install curl && \
    bash -c 'chmod +x /etc/install' && \
    /etc/install && \
    rm /etc/install && \
    apk del --no-cache .install

COPY ./overlay .

ENTRYPOINT [ "/init" ]
