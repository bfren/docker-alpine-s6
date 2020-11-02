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

RUN apk update && \
    apk upgrade && \
    apk add curl bash tzdata && \
    rm -rf /var/cache/apk/*

COPY ./install.sh /etc/install.sh
RUN bash -c 'chmod +x /etc/install.sh' && /etc/install.sh

CMD ["bash"]
