#!/bin/bash

echo "🚀 Manual VPS Deployment Guide"
echo ""
echo "VPS: root@159.65.134.137"
echo "Domain: aurapass.xyz"
echo ""
echo "=== Step 1: Upload Build ==="
echo "scp -r frontend/build/* root@159.65.134.137:/var/www/aura-frontend/"
echo ""
echo "=== Step 2: SSH to VPS ==="
echo "ssh root@159.65.134.137"
echo ""
echo "=== Step 3: On VPS, run: ==="
cat << 'COMMANDS'
# Set permissions
sudo chown -R www-data:www-data /var/www/aura-frontend

# Reload Nginx
sudo systemctl reload nginx

# Check status
sudo systemctl status nginx
COMMANDS
echo ""
echo "=== Or use rsync (faster): ==="
echo "rsync -avz --delete frontend/build/ root@159.65.134.137:/var/www/aura-frontend/"
