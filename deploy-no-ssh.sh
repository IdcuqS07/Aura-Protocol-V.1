#!/bin/bash

echo "🚀 Deploying Frontend to VPS"
echo "============================="
echo ""

# Get VPS details from user
read -p "Enter VPS IP address: " VPS_IP
read -p "Enter VPS user (default: root): " VPS_USER
VPS_USER=${VPS_USER:-root}

echo ""
echo "📤 Step 1: Uploading build.tar.gz to ${VPS_USER}@${VPS_IP}..."
scp frontend/build.tar.gz ${VPS_USER}@${VPS_IP}:/tmp/
if [ $? -ne 0 ]; then
    echo "❌ Upload failed!"
    exit 1
fi
echo "✅ Upload complete!"
echo ""

echo "📦 Step 2: Deploying on VPS..."
ssh ${VPS_USER}@${VPS_IP} << 'ENDSSH'
cd /var/www/aurapass.xyz
rm -rf *
tar xzf /tmp/build.tar.gz
chown -R www-data:www-data /var/www/aurapass.xyz
chmod -R 755 /var/www/aurapass.xyz
rm /tmp/build.tar.gz
nginx -t && systemctl reload nginx
echo "✅ Deployment complete on VPS!"
ENDSSH

if [ $? -ne 0 ]; then
    echo "❌ Deployment failed!"
    exit 1
fi

echo ""
echo "🎉 SUCCESS! Frontend deployed to VPS"
echo ""
echo "🌐 Test now:"
echo "   https://www.aurapass.xyz/passport"
echo ""
echo "Features deployed:"
echo "  ✅ AI Risk Oracle section"
echo "  ✅ Risk Score (0-100)"
echo "  ✅ Trust Score"
echo "  ✅ Confidence level"
echo "  ✅ Risk factors analysis"
