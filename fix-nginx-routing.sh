#!/bin/bash

# Auto-fix Nginx Routing for PoH
# Usage: bash fix-nginx-routing.sh

echo "🔧 Fixing Nginx Routing for PoH..."
echo ""

ssh root@159.65.134.137 << 'ENDSSH'

echo "1️⃣ Check current Nginx config..."
cat /etc/nginx/sites-available/aurapass.xyz | grep -A 5 "location /api"

echo ""
echo "2️⃣ Backup current config..."
cp /etc/nginx/sites-available/aurapass.xyz /etc/nginx/sites-available/aurapass.xyz.backup

echo ""
echo "3️⃣ Check which backend is running..."
pm2 list

echo ""
echo "4️⃣ Check backend port..."
netstat -tlnp | grep :9000 || ss -tlnp | grep :9000

echo ""
echo "5️⃣ Test backend directly..."
curl -s http://localhost:9000/api/ | head -5

echo ""
echo "6️⃣ Test PoH endpoint directly..."
curl -s -X POST http://localhost:9000/api/poh/enroll \
  -H "Content-Type: application/json" \
  -d '{"user_id":"test","wallet_address":"0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"}' | head -10

echo ""
echo "7️⃣ Restart Nginx..."
sudo systemctl restart nginx

echo ""
echo "8️⃣ Check Nginx status..."
sudo systemctl status nginx --no-pager | head -10

echo ""
echo "9️⃣ Test through Nginx..."
curl -s https://www.aurapass.xyz/api/ | head -5

echo ""
echo "🔟 Test PoH through Nginx..."
curl -s -X POST https://www.aurapass.xyz/api/poh/enroll \
  -H "Content-Type: application/json" \
  -d '{"user_id":"test","wallet_address":"0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"}' | head -10

ENDSSH

echo ""
echo "✅ Diagnostic complete!"
echo ""
echo "📝 Analysis:"
echo "  - If backend:9000 works but nginx doesn't → Nginx config issue"
echo "  - If both work → Success!"
echo "  - If neither works → Backend issue"
