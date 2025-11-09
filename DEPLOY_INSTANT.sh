#!/bin/bash
# Instant Deploy - Run this to deploy everything

VPS="root@159.65.134.137"

echo "🚀 Deploying to VPS..."

ssh $VPS << 'ENDSSH'
set -e
cd /var/www/Aura-Protocol-V.1

echo "📥 Pulling code..."
git pull origin main

echo "🔧 Starting backend..."
cd backend
pm2 restart aura-backend 2>/dev/null || pm2 start server.py --name aura-backend --interpreter python3

echo "📦 Building frontend..."
cd ../frontend
yarn install --silent
yarn build

echo "✅ Done!"
pm2 status
ENDSSH

echo ""
echo "✅ Deployed! Visit: https://www.aurapass.xyz"
