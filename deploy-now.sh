#!/bin/bash

echo "🚀 Deploying AI Risk Oracle to VPS"
echo "===================================="
echo ""

# Check if build exists
if [ ! -d "frontend/build" ]; then
    echo "❌ Build folder not found!"
    echo "Run: cd frontend && yarn build"
    exit 1
fi

echo "📦 Build folder found: frontend/build"
echo ""

# Create tar archive
echo "📦 Creating archive..."
cd frontend/build
tar czf ../build.tar.gz .
cd ../..
echo "✅ Archive created: frontend/build.tar.gz"
echo ""

# Upload to VPS
echo "📤 Uploading to VPS..."
echo "Command: scp frontend/build.tar.gz root@103.127.132.132:/tmp/"
scp frontend/build.tar.gz root@103.127.132.132:/tmp/

if [ $? -ne 0 ]; then
    echo ""
    echo "❌ Upload failed!"
    echo ""
    echo "Please run manually:"
    echo "  scp frontend/build.tar.gz root@103.127.132.132:/tmp/"
    echo ""
    echo "Then SSH to VPS and run:"
    echo "  cd /var/www/aurapass.xyz"
    echo "  tar xzf /tmp/build.tar.gz"
    echo "  chown -R www-data:www-data /var/www/aurapass.xyz"
    echo "  chmod -R 755 /var/www/aurapass.xyz"
    echo "  nginx -t && systemctl reload nginx"
    exit 1
fi

echo "✅ Upload successful!"
echo ""

# Extract on VPS
echo "📦 Extracting on VPS..."
ssh root@103.127.132.132 << 'ENDSSH'
cd /var/www/aurapass.xyz
rm -rf *
tar xzf /tmp/build.tar.gz
chown -R www-data:www-data /var/www/aurapass.xyz
chmod -R 755 /var/www/aurapass.xyz
rm /tmp/build.tar.gz
echo "✅ Files extracted and permissions set"
ENDSSH

if [ $? -ne 0 ]; then
    echo "❌ Extraction failed!"
    exit 1
fi

echo ""
echo "🔄 Reloading Nginx..."
ssh root@103.127.132.132 "nginx -t && systemctl reload nginx"

echo ""
echo "✅ Deployment Complete!"
echo ""
echo "🌐 Visit: https://www.aurapass.xyz/passport"
echo ""
echo "New Features:"
echo "  ✅ AI Risk Oracle section"
echo "  ✅ Risk Score (0-100)"
echo "  ✅ Trust Score"
echo "  ✅ Confidence level"
echo "  ✅ Risk factors analysis"
echo ""
echo "Test it:"
echo "  1. Connect wallet"
echo "  2. Scroll to 'AI Risk Oracle' section"
echo "  3. Click 'Generate AI Risk Assessment'"
echo ""

# Cleanup
rm frontend/build.tar.gz
echo "🧹 Cleaned up local archive"
