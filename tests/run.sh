#!/bin/bash

set -euo pipefail


#======================================================================================================================
# Welcome message.
#======================================================================================================================

echo "Welcome to the test suite."

ls /
ls .
ls /shUnit2


#======================================================================================================================
# Load all tests.
#======================================================================================================================

for FILE in $(find . -type f -name "test-*.sh") ; do
    echo "Running tests in ${FILE}."
    ${FILE}
done


#======================================================================================================================
# End message.
#======================================================================================================================

echo "Testing complete."
