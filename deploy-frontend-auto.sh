#!/bin/bash

# Automated Frontend Deployment
# Builds locally, uploads to VPS
# Usage: bash deploy-frontend-auto.sh

echo "🚀 Automated Frontend Deployment"
echo "================================"
echo ""

# Step 1: Build locally
echo "1️⃣ Building frontend locally..."
cd frontend || exit 1

echo "   Installing dependencies..."
yarn install

echo "   Building..."
REACT_APP_BACKEND_URL=https://www.aurapass.xyz yarn build

if [ ! -d "build" ]; then
    echo "❌ Build failed!"
    exit 1
fi

echo "✅ Build complete!"
echo ""

# Step 2: Upload to VPS
echo "2️⃣ Uploading to VPS..."
rsync -avz --delete build/ root@159.65.134.137:/var/www/aurapass.xyz/

echo "✅ Upload complete!"
echo ""

# Step 3: Set permissions
echo "3️⃣ Setting permissions..."
ssh root@159.65.134.137 << 'ENDSSH'
chown -R www-data:www-data /var/www/aurapass.xyz
systemctl reload nginx
echo "✅ Permissions set, Nginx reloaded"
ENDSSH

echo ""
echo "4️⃣ Testing deployment..."
sleep 2
curl -s https://www.aurapass.xyz/ | grep -o "<title>.*</title>"

echo ""
echo "🎉 Deployment complete!"
echo ""
echo "📝 Test these URLs:"
echo "  - https://www.aurapass.xyz/"
echo "  - https://www.aurapass.xyz/passport"
echo "  - https://www.aurapass.xyz/poh"
