#!/bin/bash
# Emergency fix for localhost:9000 issue

echo "🔧 EMERGENCY FIX: Rebuilding frontend with correct backend URL"

cd frontend

# Clean old build
echo "🧹 Cleaning old build..."
rm -rf build/

# Rebuild with production env
echo "🏗️ Building frontend..."
REACT_APP_BACKEND_URL=http://159.65.134.137:9000 yarn build

# Create tarball
echo "📦 Creating tarball..."
cd build
tar czf ../build.tar.gz .
cd ..

echo "✅ Build complete! Now upload to VPS:"
echo ""
echo "scp build.tar.gz root@159.65.134.137:/tmp/"
echo "ssh root@159.65.134.137"
echo "cd /var/www/aurapass.xyz && rm -rf * && tar xzf /tmp/build.tar.gz && chown -R www-data:www-data . && chmod -R 755 ."
echo "systemctl reload nginx"
