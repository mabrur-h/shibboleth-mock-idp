#!/bin/sh

# Generate nginx config using Railway PORT
envsubst < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf

# Start nginx in background
nginx

# Start mock-idp in foreground
exec mock-idp --host 0.0.0.0 --port 5000 