#!/bin/bash

echo "🚀 Deploying Credit Passport Backend to VPS..."
echo ""

# VPS commands
cat << 'COMMANDS'
# Copy and paste these commands in VPS terminal:

cd /root/Aura-Protocol-V.1-main/backend
git pull
sudo systemctl restart aura-backend
sleep 3
sudo systemctl status aura-backend

# Test endpoints:
curl -X POST http://localhost:9000/api/passport/calculate-score \
  -H "Content-Type: application/json" \
  -d '{"wallet_address": "0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"}'

COMMANDS

echo ""
echo "📝 After deployment, test from local:"
echo ""
echo "curl -X POST https://www.aurapass.xyz/api/passport/calculate-score \\"
echo "  -H \"Content-Type: application/json\" \\"
echo "  -d '{\"wallet_address\": \"0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1\"}' | python3 -m json.tool"
