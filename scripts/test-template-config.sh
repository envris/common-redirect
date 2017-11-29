#!/bin/bash

# Exit on error
set -e

# Set test params
export HTTPD_CONFIG_FILE="/tmp/test-template-config"
export REDIRECT_DEFS="/apps/.*:apps/login,/admin/.*:admin/login"
expected_output_file="./test-template-expected"

echo "TEST: Removing old temporary config file..."
rm -f "${HTTPD_CONFIG_FILE}"

echo "TEST: Running test target..."
# Run script
../httpd-pre-init/template-config.sh
echo "TEST: Test target terminated..."


echo "TEST: Checking output file..."


if diff -q "${expected_output_file}" "${HTTPD_CONFIG_FILE}"; then
    echo "TEST: Test passed!"
else
    echo "TEST: Test failed. Diff is shown below"
    diff "${expected_output_file}" "${HTTPD_CONFIG_FILE}"
    exit 1
fi

echo "TEST: Checking for fail if run twice..."

if ../httpd-pre-init/template-config.sh; then
    echo "TEST: Test target ran successfully. Test failed"
    exit 1
else
    echo "TEST: Test target failed. Test succeeded"
fi


echo "TEST: Finished."
