#!/bin/bash

set -euo pipefail


testEquality() {
    assertEquals 1 1
}

. ${SHUNIT2}
