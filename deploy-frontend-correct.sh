#!/bin/bash

# Deploy Frontend - Correct Version
# Usage: bash deploy-frontend-correct.sh

echo "🚀 Deploying Frontend Updates..."
echo ""

ssh root@159.65.134.137 << 'ENDSSH'

echo "1️⃣ Go to frontend repo..."
cd /var/www/aura-frontend

echo ""
echo "2️⃣ Pull latest code..."
git stash
git pull origin main

echo ""
echo "3️⃣ Install dependencies..."
yarn install

echo ""
echo "4️⃣ Build frontend..."
REACT_APP_BACKEND_URL=https://www.aurapass.xyz yarn build

echo ""
echo "5️⃣ Backup current production..."
rm -rf /var/www/aurapass.xyz.backup
cp -r /var/www/aurapass.xyz /var/www/aurapass.xyz.backup

echo ""
echo "6️⃣ Deploy new build..."
rm -rf /var/www/aurapass.xyz/*
cp -r build/* /var/www/aurapass.xyz/

echo ""
echo "7️⃣ Set permissions..."
chown -R www-data:www-data /var/www/aurapass.xyz

echo ""
echo "8️⃣ Reload Nginx..."
sudo systemctl reload nginx

echo ""
echo "9️⃣ Test deployment..."
curl -s https://www.aurapass.xyz/ | grep -o "<title>.*</title>"

ENDSSH

echo ""
echo "✅ Frontend deployed!"
echo ""
echo "📝 Test:"
echo "  https://www.aurapass.xyz/passport"
echo "  https://www.aurapass.xyz/poh"
