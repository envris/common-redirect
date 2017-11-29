#!/bin/bash

#
# Injects config into a HTTPD/Apache config file to perform redirection based on an environment variable
#
# It should only be run once when the container is started to bootstrap the config
#
# The REDIRECT_DEFS environment variable should conform to the following syntax
#  - A comma seperated list of redirect definitions
#    - WHERE a redirect definition is a colon separated pair
#       - WHERE the left side is a regex to match for the definition (.* will match all paths)
#       - WHERE the right side is a path to redirect the requestor to
#
# For example, if REDIRECT_DEFS was set to
#
#   "/apps/.*:apps/login,/admin/.*:admin/login"
#
# the following config would be generated
#
#   <VirtualHost *:8080>
#       RewriteEngine On
#       RewriteRule "(/apps/.*)" "https://%{HTTP_HOST}/apps/login" [R]
#       RewriteRule "(/admin/.*)" "https://%{HTTP_HOST}/admin/login" [R]
#   </VirtualHost>
#
# Which would redirect any vistors to the /apps/ path to to /apps/login and any visitors to the /admin/
# path to the /admin/login path.
#
# Optionally, the HTTPD_CONFIG_FILE envrionment variable can be set to override where the config file is.
#


# Exit on error
set -e

# Check required variables
if [ -z "$REDIRECT_DEFS" ]; then
    echo "Error: REDIRECT_DEFS is undefined"
    exit 1
fi

# Constants
generation_marker="# httpd-redirect autogenerated"
default_config_path="/tmp/httpd.conf"

# Set default values
output_file=${HTTPD_CONFIG_FILE:-${default_config_path}}

# Split comma separated list into 'defs' array
IFS="," read -ra defs <<< "$REDIRECT_DEFS"

echo "Will write to config file at: ${output_file}"

# Check this script is not running twice
if [ -e "${output_file}" ] && grep -q "${generation_marker}" "${output_file}"; then
    echo "Configuration already added to config file. Will not generate again."
    exit 1
fi

echo "Writing header..."

echo "${generation_marker} - start" >> "${output_file}"
echo "LoadModule rewrite_module modules/mod_rewrite.so" >> "${output_file}"
echo "<VirtualHost *:8080>" >> "${output_file}"
echo "    RewriteEngine On" >> "${output_file}"

for def in "${defs[@]}"; do
    echo "Writing config entry..."

    # Split colon separated pair into two variables
    IFS=':' read match_regex target_path <<< "$def"
    # Write entry
    echo "    RewriteRule \"(${match_regex})\" \"https://%{HTTP_HOST}/${target_path}\" [R]" >> "${output_file}"
done

echo "Writing footer..."

echo "</VirtualHost>"  >> "${output_file}"
echo "${generation_marker} - end" >> "${output_file}"

echo "Done"
