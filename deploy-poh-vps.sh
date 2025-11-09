#!/bin/bash

# Quick Deploy PoH to VPS
# Usage: bash deploy-poh-vps.sh

echo "🚀 Deploying PoH to VPS..."
echo ""

VPS_IP="159.65.134.137"
VPS_USER="root"
BACKEND_PATH="/var/www/aura-backend-new"

echo "📡 Connecting to VPS: $VPS_USER@$VPS_IP"
echo ""

ssh $VPS_USER@$VPS_IP << 'ENDSSH'
echo "📂 Navigating to backend..."
cd /var/www/aura-backend-new || exit 1

echo "📥 Pulling latest code..."
git stash
git pull origin main

echo "📦 Installing dependencies..."
source venv/bin/activate
pip install httpx -q

echo "🔄 Restarting backend..."
pm2 restart aura-backend

echo ""
echo "⏳ Waiting for backend to start..."
sleep 3

echo "🧪 Testing backend..."
curl -s http://localhost:9000/api/ | head -5

echo ""
echo "🧪 Testing PoH endpoint..."
curl -s -X POST http://localhost:9000/api/poh/enroll \
  -H "Content-Type: application/json" \
  -d '{"user_id":"test","wallet_address":"0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"}' \
  | head -10

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📝 Next steps:"
echo "1. Go to: https://www.aurapass.xyz/poh"
echo "2. Test enrollment"
echo "3. Check if error is gone"
ENDSSH

echo ""
echo "🎉 Done! Check VPS output above."
