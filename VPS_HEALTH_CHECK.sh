#!/bin/bash

# VPS Health Check - Aura Protocol
VPS_IP="159.65.134.137"

echo "🔍 Aura Protocol - VPS Health Check"
echo "===================================="
echo ""

# 1. Backend Status
echo "📊 1. Backend Status"
echo "-------------------"
ssh root@${VPS_IP} << 'EOF'
pm2 status
echo ""
echo "Backend Process Info:"
ps aux | grep uvicorn | grep -v grep | head -3
EOF
echo ""

# 2. Test Backend Endpoints
echo "🧪 2. Testing Backend Endpoints"
echo "-------------------------------"

echo "→ Analytics:"
curl -s -m 5 http://${VPS_IP}:9000/api/analytics | head -5 && echo "✅" || echo "❌"

echo "→ PoH Enroll:"
curl -s -m 5 -X POST http://${VPS_IP}:9000/api/poh/enroll \
  -H "Content-Type: application/json" \
  -d '{"user_id":"health_check","wallet_address":"0xHEALTH"}' | head -5 && echo "✅" || echo "❌"

echo ""

# 3. Frontend Status
echo "🌐 3. Frontend Status"
echo "--------------------"
ssh root@${VPS_IP} << 'EOF'
echo "Files in /var/www/aurapass.xyz:"
ls -lh /var/www/aurapass.xyz | head -10
echo ""
echo "Nginx Status:"
systemctl status nginx | grep Active
EOF
echo ""

# 4. Database Status
echo "💾 4. Database Status"
echo "--------------------"
ssh root@${VPS_IP} << 'EOF'
echo "MongoDB Status:"
systemctl status mongod | grep Active
echo ""
echo "Database Stats:"
mongosh aura_protocol --quiet --eval "
  print('Enrollments: ' + db.enrollments.countDocuments());
  print('Proofs: ' + db.proofs.countDocuments());
  print('Badges: ' + db.badges.countDocuments());
  print('Passports: ' + db.passports.countDocuments());
"
EOF
echo ""

# 5. System Resources
echo "💻 5. System Resources"
echo "---------------------"
ssh root@${VPS_IP} << 'EOF'
echo "CPU & Memory:"
top -bn1 | head -5
echo ""
echo "Disk Usage:"
df -h / | tail -1
EOF
echo ""

# 6. Recent Logs
echo "📝 6. Recent Backend Logs"
echo "------------------------"
ssh root@${VPS_IP} "pm2 logs aura-backend --lines 10 --nostream | tail -15"
echo ""

# 7. Network Connectivity
echo "🌍 7. Network Connectivity"
echo "-------------------------"
echo "→ Backend Port 9000:"
nc -zv ${VPS_IP} 9000 2>&1 | grep -q succeeded && echo "✅ Open" || echo "❌ Closed"

echo "→ Frontend Port 80:"
nc -zv ${VPS_IP} 80 2>&1 | grep -q succeeded && echo "✅ Open" || echo "❌ Closed"

echo ""
echo "✅ Health Check Complete!"
