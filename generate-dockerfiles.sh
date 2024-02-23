#!/bin/bash

set -euo pipefail

docker pull bfren/alpine

BASE_VERSION="2.2.3"
S6_VERSION="3.1.6.2"
echo "Base: ${BASE_VERSION}"

ALPINE_EDITIONS="3.15 3.16 3.17 3.18 3.19"
for E in ${ALPINE_EDITIONS} ; do

    echo "Alpine ${E}"
    ALPINE_VERSION=`cat ./${E}/ALPINE_REVISION`

    DOCKERFILE=$(docker run \
        -v ${PWD}:/ws \
        -e BF_DEBUG=0 \
        bfren/alpine esh \
        "/ws/Dockerfile.esh" \
        ALPINE_VERSION=${ALPINE_VERSION} \
        BASE_VERSION=${BASE_VERSION} \
        S6_VERSION=${S6_VERSION}
    )

    echo "${DOCKERFILE}" > ./${E}/Dockerfile

done

docker system prune -f
echo "Done."
