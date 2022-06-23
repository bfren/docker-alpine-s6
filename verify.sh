#!/bin/sh

IMAGE="alpine-s6"
TAG="${0}"

echo "Running ${IMAGE}:${TAG}"
timeout --signal=KILL 120s bash -c "docker run bfren/${IMAGE}:${TAG} bf-image"
exit $?
