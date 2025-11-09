#!/bin/bash

# Fix Backend Systemd Service on VPS
# This script fixes the incorrect path in aura-backend.service

VPS_IP="159.65.134.137"
VPS_USER="root"

echo "🔧 Fixing Backend Systemd Service on VPS..."
echo "================================================"

# Create correct service file
cat > /tmp/aura-backend.service << 'EOF'
[Unit]
Description=Aura Protocol Backend API
After=network.target mongodb.service

[Service]
Type=simple
User=root
WorkingDirectory=/var/www/Aura-Protocol-V.1/backend
Environment="PATH=/var/www/Aura-Protocol-V.1/backend/venv/bin"
ExecStart=/var/www/Aura-Protocol-V.1/backend/venv/bin/uvicorn server:app --host 0.0.0.0 --port 9000
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

echo "✅ Service file created locally"

# Upload and install service file
echo ""
echo "📤 Uploading service file to VPS..."
scp /tmp/aura-backend.service ${VPS_USER}@${VPS_IP}:/tmp/

echo ""
echo "🔄 Installing and restarting service..."
ssh ${VPS_USER}@${VPS_IP} << 'ENDSSH'
# Move service file
sudo mv /tmp/aura-backend.service /etc/systemd/system/aura-backend.service

# Reload systemd
sudo systemctl daemon-reload

# Enable service
sudo systemctl enable aura-backend

# Restart service
sudo systemctl restart aura-backend

# Wait 3 seconds
sleep 3

# Check status
echo ""
echo "📊 Service Status:"
sudo systemctl status aura-backend --no-pager

echo ""
echo "🔍 Checking if API is responding..."
curl -s http://localhost:9000/ | head -n 5

echo ""
echo "✅ Backend service fix complete!"
ENDSSH

# Cleanup
rm /tmp/aura-backend.service

echo ""
echo "================================================"
echo "✅ Fix Complete!"
echo ""
echo "To verify manually:"
echo "  ssh root@${VPS_IP}"
echo "  systemctl status aura-backend"
echo "  curl http://localhost:9000/"
