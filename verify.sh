#!/bin/sh

IMAGE="${1}"
PLATFORMS="${2}"
for P in `echo ${PLATFORMS} | tr "," " "` ; do
    timeout --signal=KILL 60s bash -c "docker run --rm --platform=${P} bfren/${IMAGE}:test bf-image"
    [[ "$?" -ne "0" ]] && exit $?
done
