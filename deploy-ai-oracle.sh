#!/bin/bash

echo "🤖 Deploying AI Risk Oracle to VPS"
echo "===================================="
echo ""

# Build frontend locally
echo "📦 Building frontend..."
cd frontend
yarn build
if [ $? -ne 0 ]; then
    echo "❌ Frontend build failed!"
    exit 1
fi
cd ..

echo ""
echo "✅ Frontend built successfully!"
echo ""

# Upload to VPS
echo "📤 Uploading to VPS..."
rsync -avz --progress frontend/build/ root@103.127.132.132:/var/www/aurapass.xyz/

echo ""
echo "🔧 Setting permissions..."
ssh root@103.127.132.132 "chown -R www-data:www-data /var/www/aurapass.xyz && chmod -R 755 /var/www/aurapass.xyz"

echo ""
echo "🔄 Reloading Nginx..."
ssh root@103.127.132.132 "nginx -t && systemctl reload nginx"

echo ""
echo "✅ AI Risk Oracle deployed successfully!"
echo ""
echo "🌐 Visit: https://www.aurapass.xyz/passport"
echo ""
echo "Features added:"
echo "  ✅ AI Risk Score (0-100)"
echo "  ✅ Trust Score calculation"
echo "  ✅ Confidence level"
echo "  ✅ Risk factors analysis"
echo "  ✅ Real-time prediction"
