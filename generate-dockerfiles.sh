#!/bin/bash

set -euo pipefail

docker pull bfren/alpine

BASE_REVISION="2.0.0-beta"
S6_VERSION="3.1.5.0"
echo "Base: ${BASE_REVISION}"

ALPINE_VERSIONS="3.15 3.16 3.17 3.18"
for V in ${ALPINE_VERSIONS} ; do

    echo "Alpine ${V}"

    DOCKERFILE=$(docker run \
        -v ${PWD}:/ws \
        -e BF_DEBUG=0 \
        bfren/alpine esh \
        "/ws/Dockerfile.esh" \
        BASE_REVISION=${BASE_REVISION} \
        S6_VERSION=${S6_VERSION} \
        ALPINE_MINOR=${V}
    )

    echo "${DOCKERFILE}" > ./${V}/Dockerfile

done

docker system prune -f
echo "Done."
