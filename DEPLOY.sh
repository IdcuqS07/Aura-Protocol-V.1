#!/bin/bash

# Aura Protocol - Automated Deployment Script
# Usage: ./deploy.sh

set -e  # Exit on error

VPS_IP="159.65.134.137"
VPS_USER="root"
FRONTEND_DIR="frontend"
BUILD_FILE="build.tar.gz"

echo "🚀 Starting Aura Protocol Deployment..."
echo ""

# Step 1: Build Frontend
echo "📦 Step 1/5: Building frontend..."
cd $FRONTEND_DIR
yarn build
tar -czf $BUILD_FILE build/
echo "✅ Frontend built successfully"
echo ""

# Step 2: Upload Frontend
echo "📤 Step 2/5: Uploading frontend to VPS..."
scp $BUILD_FILE $VPS_USER@$VPS_IP:/tmp/
echo "✅ Frontend uploaded"
echo ""

# Step 3: Deploy Frontend
echo "🌐 Step 3/5: Deploying frontend..."
ssh $VPS_USER@$VPS_IP << 'ENDSSH'
cd /var/www/aurapass.xyz
rm -rf *
tar -xzf /tmp/build.tar.gz --strip-components=1
rm /tmp/build.tar.gz
echo "✅ Frontend deployed to /var/www/aurapass.xyz"
ENDSSH
echo ""

# Step 4: Update Backend
echo "🔧 Step 4/5: Updating backend..."
ssh $VPS_USER@$VPS_IP << 'ENDSSH'
cd /root/Aura-Protocol-V.1-main
git pull origin main
echo "✅ Backend code updated"
ENDSSH
echo ""

# Step 5: Restart Backend
echo "🔄 Step 5/5: Restarting backend service..."
ssh $VPS_USER@$VPS_IP << 'ENDSSH'
systemctl restart aura-backend
sleep 3
systemctl status aura-backend --no-pager | head -10
echo "✅ Backend restarted"
ENDSSH
echo ""

# Cleanup
cd ..
rm -f $FRONTEND_DIR/$BUILD_FILE

echo "🎉 Deployment Complete!"
echo ""
echo "🌐 Website: https://www.aurapass.xyz"
echo "📊 Check logs: ssh $VPS_USER@$VPS_IP 'journalctl -u aura-backend.service -n 50 -f'"
echo ""
