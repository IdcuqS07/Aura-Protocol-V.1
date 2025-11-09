#!/bin/bash

# Fix VPS Deployment Issues
# Usage: bash fix-vps-deployment.sh

echo "🔧 Fixing VPS Deployment Issues..."
echo ""

ssh root@159.65.134.137 << 'ENDSSH'

echo "1️⃣ Fix git ownership..."
cd /var/www/aura-backend-new
git config --global --add safe.directory /var/www/aura-backend-new

echo ""
echo "2️⃣ Pull latest code..."
git stash
git pull origin main

echo ""
echo "3️⃣ Check if PoH files exist..."
ls -la poh_routes.py github_service.py twitter_service.py onchain_service.py polygon_id_service.py credit_scoring.py 2>/dev/null || echo "⚠️  Some files missing!"

echo ""
echo "4️⃣ Check server.py includes PoH router..."
grep -n "poh_router" server.py || echo "⚠️  PoH router not imported in server.py!"

echo ""
echo "5️⃣ Install dependencies (system-wide since no venv)..."
pip3 install httpx -q

echo ""
echo "6️⃣ Restart backend..."
pm2 restart aura-backend

echo ""
echo "7️⃣ Wait for startup..."
sleep 5

echo ""
echo "8️⃣ Check PM2 logs..."
pm2 logs aura-backend --lines 30 --nostream

echo ""
echo "9️⃣ Test PoH endpoint..."
curl -X POST http://localhost:9000/api/poh/enroll \
  -H "Content-Type: application/json" \
  -d '{"user_id":"test","wallet_address":"0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"}' 2>/dev/null | head -20

echo ""
echo "🔟 List all API endpoints..."
curl -s http://localhost:9000/docs | grep -o '/api/[^"]*' | sort | uniq | head -20

ENDSSH

echo ""
echo "✅ Diagnostic complete!"
echo ""
echo "📝 Check output above for:"
echo "  - PoH files exist?"
echo "  - PoH router imported?"
echo "  - Backend errors in logs?"
echo "  - /api/poh/enroll endpoint available?"
