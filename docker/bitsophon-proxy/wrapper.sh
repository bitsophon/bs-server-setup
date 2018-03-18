#!/bin/sh

set -e

# Replace the server list
echo "EVN: $EVN"

# Create symlinks to enable sites
# STATIC
ln -s /etc/nginx/sites-available/www.bitsophon.com /etc/nginx/sites-enabled/

# Start the server
nginx
