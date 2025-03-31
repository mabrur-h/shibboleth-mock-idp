#!/bin/sh

# Process nginx configuration template to replace environment variables
envsubst '$PORT' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Start supervisord to manage both services
/usr/bin/supervisord -c /etc/supervisord.conf 