#!/bin/sh

IMAGE=`cat VERSION`
ALPINE=${1:-3.19}

docker buildx build \
    --load \
    --build-arg BF_IMAGE=alpine-s6 \
    --build-arg BF_VERSION=${IMAGE} \
    -f ${ALPINE}/Dockerfile \
    -t alpine${ALPINE}-s6-test \
    . \
    && \
    docker run --rm alpine${ALPINE}-s6-test env -i nu -c "use bf test ; test"
