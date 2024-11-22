#!/bin/sh

IMAGE=alpine-s6
VERSION=`cat VERSION`
ALPINE=${1:-3.20}
TAG=${IMAGE}-test

docker buildx build \
    --load \
    --build-arg BF_IMAGE=${IMAGE} \
    --build-arg BF_VERSION=${VERSION} \
    -f ${ALPINE}/Dockerfile \
    -t ${TAG} \
    . \
    && \
    docker run --entrypoint /test ${TAG}
