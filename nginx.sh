#!/bin/bash
#
echo "Starting nginx..."
nginx &
tail -F /var/log/nginx/access.log