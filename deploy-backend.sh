#!/bin/bash
# Deploy backend to VPS

echo "🚀 Deploying backend to VPS..."

ssh root@YOUR_VPS_IP << 'EOF'
cd /root/Aura-Protocol-V.1-main
git pull
sudo systemctl restart aura-backend
sudo systemctl status aura-backend --no-pager
echo "✅ Backend deployed and restarted"
EOF

echo "🎉 Deployment complete!"
