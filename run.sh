#!/bin/sh

VERSION=`cat VERSION`

git pull || true

docker buildx build \
    --build-arg BF_IMAGE=alpine-s6 \
    --build-arg BF_VERSION=${VERSION} \
    -f 3.15/Dockerfile \
    -t alpine-s6-dev \
    .

docker run -it alpine-s6-dev sh