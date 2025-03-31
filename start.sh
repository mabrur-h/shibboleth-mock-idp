#!/bin/sh

# Debugging information
echo "Current directory: $(pwd)"
echo "Network interfaces and configuration:"
ip addr show || echo "ip command not found"

echo "Environment variables:"
printenv | grep -E 'PORT|HOST|URL' || echo "No relevant environment variables found"

echo "Listing nginx config templates directory:"
ls -la /etc/nginx/templates/
echo "Listing HTML directory:"
ls -la /usr/share/nginx/html/

# Copy metadata.xml to location with simple name for testing
cp /usr/share/nginx/html/metadata.xml /usr/share/nginx/html/meta.xml

# Manual approach - avoid envsubst completely
NGINX_CONF="/etc/nginx/conf.d/default.conf"
cat > "$NGINX_CONF" << EOF
server {
    listen ${PORT} default_server;
    server_name _;

    # For debugging
    location = /nginx-status {
        stub_status on;
        access_log off;
        allow all;
    }

    # Directly serve the metadata XML file
    location = /metadata {
        add_header Content-Type application/xml;
        alias /usr/share/nginx/html/metadata.xml;
    }

    # Alternate simpler path for metadata
    location = /meta.xml {
        add_header Content-Type application/xml;
        root /usr/share/nginx/html;
    }

    # Test HTML page
    location = /test.html {
        root /usr/share/nginx/html;
    }

    # Root HTML page
    location = / {
        root /usr/share/nginx/html;
        index index.html;
    }

    # Simplified proxy
    location /idp/ {
        proxy_pass http://localhost:8000/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

# Verify configuration
echo "Generated Nginx configuration:"
cat "$NGINX_CONF"

nginx -t || {
  echo "Nginx configuration test failed. Exiting."
  exit 1
}

# Create debug index page
cat > /usr/share/nginx/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Mock IdP Server</title>
</head>
<body>
    <h1>SAML Mock IdP Server</h1>
    <p>Server is running. Available endpoints:</p>
    <ul>
        <li><a href="/metadata">Metadata (XML format)</a></li>
        <li><a href="/meta.xml">Alternate metadata path (XML format)</a></li>
        <li><a href="/test.html">Test HTML page</a></li>
        <li><a href="/nginx-status">Nginx status (for debugging)</a></li>
        <li><a href="/idp/">IdP Application</a></li>
    </ul>
</body>
</html>
EOF

# Start nginx in background
echo "Starting Nginx..."
nginx &
NGINX_PID=$!

# Display Railway port info
echo "Railway PORT: ${PORT}"
echo "Public URL should be: https://shibboleth-idp.up.railway.app"
echo "Test URL: https://shibboleth-idp.up.railway.app/test.html"
echo "Metadata URL: https://shibboleth-idp.up.railway.app/metadata"

# Verify Nginx is working
sleep 2
echo "Testing Nginx locally:"
curl -v http://localhost:${PORT}/ || echo "Curl failed for Nginx local test"

# Start mock-idp and keep the container running
echo "Starting Mock IdP on port 8000..."
exec mock-idp --host 0.0.0.0 --port 8000 