FROM --platform=$BUILDPLATFORM golang:alpine AS build

ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN echo "Build: $BUILDPLATFORM, target: $TARGETPLATFORM" > /log

FROM alpine:3.12.1
COPY --from=build /log /log

ARG TARGETPLATFORM

LABEL maintainer="Ben Green <ben@bcgdesign.com>" \
    org.label-schema.name="Alpine + S6" \
    org.label-schema.version="latest" \
    org.label-schema.vendor="Ben Green" \
    org.label-schema.schema-version="1.0"

ENV \
    # set to 1 to install bash package
    WITH_BASH=0

RUN apk -U upgrade \
    && apk add tzdata \
    && rm -rf /var/cache/apk/*

COPY ./overlay /

ARG S6_VERSION=2.1.0.2
RUN chmod +x /tmp/install /usr/bin/_* \
    && /tmp/install \
    && rm -rf /tmp/*

ENTRYPOINT [ "/init" ]
