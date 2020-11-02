FROM --platform=$BUILDPLATFORM golang:alpine AS build
ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM" > /log

FROM alpine:3.12
COPY --from=build /log /log

LABEL maintainer="Ben Green <ben@bcgdesign.com>" \
    org.label-schema.name="Alpine" \
    org.label-schema.version="latest" \
    org.label-schema.vendor="Ben Green" \
    org.label-schema.schema-version="1.0"

ARG TARGETPLATFORM
ENV S6_VERSION=2.1.0.2

COPY ./install.sh /root/install.sh
WORKDIR /root

RUN apk update && \
    apk upgrade && \
    apk add curl bash tzdata && \
    rm -rf /var/cache/apk/*

RUN /bin/bash -c 'chmod +x install.sh' && \
    install.sh
