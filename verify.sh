#!/bin/bash

IMAGE="${1}"
PLATFORMS="${2}"
for P in `echo ${PLATFORMS} | tr "," " "` ; do
    echo "Testing ${IMAGE} on ${P}."
    timeout --signal=KILL 60s bash -c "docker run --rm --platform=${P} ${IMAGE} bf-image"
    [[ "$?" -ne "0" ]] && exit $?
    echo "${P} works successfully."
done
