#!/bin/bash

# Fix Nginx Port Mismatch
# Changes proxy_pass from port 9001 to 9000

echo "🔧 Fixing Nginx Port (9001 → 9000)..."
echo ""

ssh root@159.65.134.137 << 'ENDSSH'

echo "1️⃣ Backup Nginx config..."
sudo cp /etc/nginx/sites-available/aurapass.xyz /etc/nginx/sites-available/aurapass.xyz.backup.$(date +%Y%m%d_%H%M%S)

echo ""
echo "2️⃣ Fix port in Nginx config..."
sudo sed -i 's/proxy_pass http:\/\/127.0.0.1:9001\//proxy_pass http:\/\/127.0.0.1:9000\//' /etc/nginx/sites-available/aurapass.xyz

echo ""
echo "3️⃣ Verify change..."
grep "proxy_pass" /etc/nginx/sites-available/aurapass.xyz | head -1

echo ""
echo "4️⃣ Test Nginx config..."
sudo nginx -t

echo ""
echo "5️⃣ Reload Nginx..."
sudo systemctl reload nginx

echo ""
echo "6️⃣ Test PoH through Nginx..."
sleep 2
curl -s -X POST https://www.aurapass.xyz/api/poh/enroll \
  -H "Content-Type: application/json" \
  -d '{"user_id":"test","wallet_address":"0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"}' \
  | python3 -m json.tool 2>/dev/null || cat

ENDSSH

echo ""
echo "✅ Port fix complete!"
echo ""
echo "📝 Next: Test on https://www.aurapass.xyz/poh"
