#!/bin/sh

IMAGE="alpine-s6"
TAG="${1}"

echo "Running ${IMAGE}:${TAG}"
timeout --signal=KILL 60s bash -c "docker run bfren/${IMAGE}:${TAG} bf-image"
exit $?
