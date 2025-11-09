#!/bin/bash

# Aura Protocol - VPS Deployment Script
# Run this script from your LOCAL machine

set -e

VPS_IP="103.127.132.132"
VPS_USER="root"
PROJECT_DIR="/root/Aura-Protocol-V.1-main"

echo "🚀 Starting Aura Protocol VPS Deployment..."

# Step 1: Push to GitHub
echo "📤 Step 1: Pushing to GitHub..."
git add .
git commit -m "Deploy: PoH, Passport, AI Oracle features" || echo "No changes to commit"
git push origin main

# Step 2: Update backend on VPS
echo "🔧 Step 2: Updating backend on VPS..."
ssh $VPS_USER@$VPS_IP << 'ENDSSH'
cd /root/Aura-Protocol-V.1-main
git pull origin main
cd backend
source venv/bin/activate
pip install -r requirements.txt
ENDSSH

# Step 3: Copy .env file
echo "📋 Step 3: Copying .env to VPS..."
scp backend/.env $VPS_USER@$VPS_IP:$PROJECT_DIR/backend/.env

# Step 4: Setup systemd service
echo "⚙️ Step 4: Setting up systemd service..."
ssh $VPS_USER@$VPS_IP << 'ENDSSH'
cat > /etc/systemd/system/aura-backend.service << 'EOF'
[Unit]
Description=Aura Protocol Backend
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/Aura-Protocol-V.1-main/backend
Environment="PATH=/root/Aura-Protocol-V.1-main/backend/venv/bin"
ExecStart=/root/Aura-Protocol-V.1-main/backend/venv/bin/uvicorn server:app --host 0.0.0.0 --port 9000
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable aura-backend
systemctl restart aura-backend
systemctl status aura-backend --no-pager
ENDSSH

# Step 5: Build and deploy frontend
echo "🎨 Step 5: Building frontend..."
cd frontend
yarn install
yarn build
tar czf build.tar.gz build/

echo "📦 Step 6: Uploading frontend to VPS..."
scp build.tar.gz $VPS_USER@$VPS_IP:/tmp/

echo "🌐 Step 7: Extracting frontend on VPS..."
ssh $VPS_USER@$VPS_IP << 'ENDSSH'
cd /var/www/aurapass.xyz
rm -rf *
tar xzf /tmp/build.tar.gz
mv build/* .
rmdir build
chown -R www-data:www-data /var/www/aurapass.xyz
chmod -R 755 /var/www/aurapass.xyz
nginx -t && systemctl reload nginx
ENDSSH

# Cleanup
rm -f frontend/build.tar.gz

echo "✅ Deployment Complete!"
echo ""
echo "🔍 Testing URLs:"
echo "   Backend:  http://$VPS_IP:9000"
echo "   Frontend: https://www.aurapass.xyz"
echo ""
echo "📊 Check backend status:"
echo "   ssh $VPS_USER@$VPS_IP 'systemctl status aura-backend'"
echo ""
echo "📝 View backend logs:"
echo "   ssh $VPS_USER@$VPS_IP 'journalctl -u aura-backend -f'"
