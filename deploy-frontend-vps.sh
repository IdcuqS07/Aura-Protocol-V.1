#!/bin/bash

# Deploy Frontend Updates to VPS
# Usage: bash deploy-frontend-vps.sh

echo "🚀 Deploying Frontend to VPS..."
echo ""

ssh root@159.65.134.137 << 'ENDSSH'

echo "1️⃣ Navigate to frontend directory..."
cd /var/www/aurapass.xyz || exit 1

echo ""
echo "2️⃣ Backup current build..."
if [ -d "build" ]; then
    mv build build.backup.$(date +%Y%m%d_%H%M%S)
    echo "✅ Backup created"
fi

echo ""
echo "3️⃣ Pull latest code..."
git stash
git pull origin main

echo ""
echo "4️⃣ Install dependencies..."
yarn install

echo ""
echo "5️⃣ Build frontend..."
REACT_APP_BACKEND_URL=https://www.aurapass.xyz yarn build

echo ""
echo "6️⃣ Check build output..."
ls -lh build/ | head -10

echo ""
echo "7️⃣ Test frontend..."
curl -s https://www.aurapass.xyz/ | grep -o "<title>.*</title>" | head -1

ENDSSH

echo ""
echo "✅ Frontend deployment complete!"
echo ""
echo "📝 Test:"
echo "  1. Go to: https://www.aurapass.xyz/passport"
echo "  2. Connect wallet"
echo "  3. Check if passport displays"
