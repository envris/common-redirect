#!/bin/bash

# Exit on error
set -e

/tmp/template-config.sh
/usr/bin/run-httpd -f /tmp/httpd.conf
