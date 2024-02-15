#!/bin/sh

IMAGE=`cat VERSION`
ALPINE=${1:-3.19}

docker buildx build \
    --load \
    --progress plain \
    --build-arg BF_IMAGE=alpine-s6 \
    --build-arg BF_VERSION=${IMAGE} \
    -f ${ALPINE}/Dockerfile \
    -t alpine${ALPINE}-s6-dev \
    . \
    && \
    docker run -it -e BF_DEBUG=1 alpine${ALPINE}-s6-dev sh
