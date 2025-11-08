#!/bin/bash

echo "🔍 Verifying Backend on Port 9000..."
echo ""

# Check if backend is running
echo "1. Checking PM2 status..."
ssh root@165.232.166.78 "pm2 status"
echo ""

# Check what's listening on port 9000
echo "2. Checking port 9000..."
ssh root@165.232.166.78 "lsof -i :9000 || netstat -tulpn | grep :9000"
echo ""

# Test API endpoint
echo "3. Testing API endpoint..."
ssh root@165.232.166.78 "curl -s http://localhost:9000/api/"
echo ""

# Check if PoH routes are loaded
echo "4. Testing PoH endpoint..."
ssh root@165.232.166.78 "curl -s -o /dev/null -w '%{http_code}' http://localhost:9000/api/poh/enroll"
echo ""

# Check server.py for port configuration
echo "5. Checking server.py port configuration..."
ssh root@165.232.166.78 "cd /var/www/aura-backend-new && grep -n 'port.*9000' server.py || echo 'Port not hardcoded in server.py (using uvicorn command)'"
echo ""

# Check PM2 process command
echo "6. Checking PM2 process command..."
ssh root@165.232.166.78 "pm2 info aura-backend | grep 'script path\|exec mode\|script args'"
echo ""

echo "✅ Verification complete!"
