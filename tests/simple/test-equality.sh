#!/bin/sh

set -euo pipefail


testEquality() {
    assertEqual 1 1
}

. ${SHUNIT2}
