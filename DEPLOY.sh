#!/bin/bash

# Aura Protocol - VPS Deployment Script
# Run this on VPS after SSH

echo "🚀 Starting Aura Protocol Deployment..."

# Pull latest code
echo "📥 Pulling latest code from GitHub..."
cd /var/www/aura-frontend
git pull origin main

# Rebuild frontend
echo "🔨 Building frontend..."
yarn build

# Restart nginx
echo "🔄 Restarting nginx..."
sudo systemctl restart nginx

echo "✅ Deployment complete!"
echo "🌐 Visit: https://www.aurapass.xyz"
echo "💡 Clear browser cache (Ctrl+Shift+R) before testing"
