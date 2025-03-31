#!/bin/sh

# Debugging information
echo "Current directory: $(pwd)"
echo "Listing nginx config templates directory:"
ls -la /etc/nginx/templates/
echo "Listing HTML directory:"
ls -la /usr/share/nginx/html/

# Copy metadata.xml to location with simple name for testing
cp /usr/share/nginx/html/metadata.xml /usr/share/nginx/html/meta.xml

# Generate nginx config using Railway PORT
echo "Creating Nginx configuration with PORT=${PORT}"
envsubst < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf

# Verify configuration
echo "Generated Nginx configuration:"
cat /etc/nginx/conf.d/default.conf

# Start nginx in background
echo "Starting Nginx..."
nginx

# Display Railway port info
echo "Railway PORT: ${PORT}"
echo "Public URL should be: https://shibboleth-idp.up.railway.app"
echo "Test URL: https://shibboleth-idp.up.railway.app/test.html"
echo "Metadata URL: https://shibboleth-idp.up.railway.app/metadata"

# Start mock-idp in foreground
echo "Starting Mock IdP..."
exec mock-idp --host 0.0.0.0 --port 5000 