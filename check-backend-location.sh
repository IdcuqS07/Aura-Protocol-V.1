#!/bin/bash

echo "🔍 Finding Which Backend is Running..."
echo ""

ssh root@159.65.134.137 << 'ENDSSH'

echo "1️⃣ Check PM2 process details..."
pm2 describe aura-backend | grep -E "script path|cwd"

echo ""
echo "2️⃣ Check process..."
ps aux | grep uvicorn | grep -v grep

echo ""
echo "3️⃣ Check /var/www/aura-backend (OLD)..."
ls -la /var/www/aura-backend/poh_routes.py 2>/dev/null && echo "✅ PoH exists in OLD" || echo "❌ No PoH in OLD"

echo ""
echo "4️⃣ Check /var/www/aura-backend-new (NEW)..."
ls -la /var/www/aura-backend-new/poh_routes.py 2>/dev/null && echo "✅ PoH exists in NEW" || echo "❌ No PoH in NEW"

echo ""
echo "5️⃣ Update PM2 to use NEW backend..."
pm2 delete aura-backend
cd /var/www/aura-backend-new
pm2 start "uvicorn server:app --host 0.0.0.0 --port 9000" --name aura-backend

echo ""
echo "6️⃣ Wait for startup..."
sleep 3

echo ""
echo "7️⃣ Test PoH endpoint..."
curl -s -X POST http://localhost:9000/api/poh/enroll \
  -H "Content-Type: application/json" \
  -d '{"user_id":"test","wallet_address":"0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"}' \
  | head -20

echo ""
echo "8️⃣ Save PM2 config..."
pm2 save

ENDSSH

echo ""
echo "✅ Backend switched to NEW location!"
echo "📝 Test: https://www.aurapass.xyz/poh"
