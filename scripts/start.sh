#!/bin/bash

# Exit on error
set -e

/tmp/template-config.sh
httpd-foreground
