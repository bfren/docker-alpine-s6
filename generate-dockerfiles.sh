#!/bin/bash

set -euo pipefail

docker pull bfren/alpine

BASE_REVISION="1.7.9"
S6_VERSION="3.1.3.0"
echo "Base: ${BASE_REVISION}"

ALPINE_VERSIONS="3.8 3.9 3.10 3.11 3.12 3.13 3.14 3.15 3.16 3.17 edge"
for V in ${ALPINE_VERSIONS} ; do

    echo "Alpine ${V}"
    ALPINE_REVISION=`cat ./${V}/ALPINE_REVISION`

    DOCKERFILE=$(docker run \
        -v ${PWD}:/ws \
        -e BF_DEBUG=0 \
        bfren/alpine esh \
        "/ws/Dockerfile.esh" \
        BASE_REVISION=${BASE_REVISION} \
        S6_VERSION=${S6_VERSION} \
        ALPINE_REVISION=${ALPINE_REVISION}
    )

    echo "${DOCKERFILE}" > ./${V}/Dockerfile

done

docker system prune -f
echo "Done."
