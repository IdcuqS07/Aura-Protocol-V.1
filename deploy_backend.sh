#!/bin/bash

# Deploy backend server.py to VPS
echo "Uploading server.py to VPS..."

scp backend/server.py root@159.65.134.137:/root/Aura-Protocol-V.1-main/backend/server.py

echo ""
echo "Restarting backend service..."
ssh root@159.65.134.137 "systemctl restart aura-backend && systemctl status aura-backend"

echo ""
echo "✅ Deployment complete!"
echo "Test: curl https://www.aurapass.xyz/api/health"
