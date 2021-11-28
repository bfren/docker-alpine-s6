#!/bin/bash

set -euo pipefail


BASE_REVISION="1.2.1"
echo "Base: ${BASE_REVISION}"

declare -A ALPINE_VERSIONS
ALPINE_VERSIONS["3.12"]="3.12.9"
ALPINE_VERSIONS["3.13"]="3.13.7"
ALPINE_VERSIONS["3.14"]="3.14.3"
ALPINE_VERSIONS["3.15"]="3.15.0"
ALPINE_VERSIONS["edge"]="edge"

for V in "${!ALPINE_VERSIONS[@]}" ; do

    echo "Alpine: ${V}"

    DOCKERFILE=$(docker run \
        -v /mnt/q/src/docker/alpine-s6/Dockerfile.esh:/Dockerfile.esh \
        bfren/alpine esh \
        "/Dockerfile.esh" \
        BASE_REVISION=${BASE_REVISION} \
        ALPINE_REVISION=${ALPINE_VERSIONS[${V}]}
    )

    echo "${DOCKERFILE}" > ./${V}/Dockerfile

done

echo "Done."
