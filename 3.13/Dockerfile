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

COPY ./overlay /
COPY ./3.13/repositories /etc/apk/repositories

ARG S6_VERSION=2.2.0.1
RUN chmod +x /tmp/install /usr/local/bin/_* \
    && /tmp/install \
    && rm -rf /tmp/* \
    && chmod a=rwx,u+t /tmp

ENTRYPOINT [ "/init" ]
