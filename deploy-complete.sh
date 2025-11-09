#!/bin/bash

# Aura Protocol - Complete Deployment Script
# This script deploys both backend and frontend to VPS

set -e  # Exit on error

echo "🚀 Aura Protocol - Complete Deployment"
echo "========================================"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

VPS_IP="159.65.134.137"
VPS_USER="root"
PROJECT_PATH="/root/Aura-Protocol-V.1-main"

echo -e "${BLUE}📦 Step 1: Building Frontend Locally${NC}"
cd frontend
yarn build
echo -e "${GREEN}✅ Frontend built successfully${NC}"
echo ""

echo -e "${BLUE}📤 Step 2: Deploying to VPS${NC}"
echo "Connecting to ${VPS_USER}@${VPS_IP}..."
echo ""

ssh ${VPS_USER}@${VPS_IP} << 'ENDSSH'
set -e

echo "📥 Pulling latest code..."
cd /root/Aura-Protocol-V.1-main
git pull origin main

echo "📦 Installing frontend dependencies..."
cd frontend
yarn install

echo "🔨 Building frontend on VPS..."
yarn build

echo "🔄 Restarting backend service..."
cd ../backend
pm2 restart aura-backend || pm2 start server.py --name aura-backend --interpreter python3

echo "✅ Deployment complete!"
echo ""
echo "📊 Service Status:"
pm2 status

echo ""
echo "📝 Recent logs:"
pm2 logs aura-backend --lines 10 --nostream

ENDSSH

echo ""
echo -e "${GREEN}✅ Deployment Complete!${NC}"
echo ""
echo "🌐 URLs:"
echo "  Frontend: https://www.aurapass.xyz"
echo "  Backend:  http://159.65.134.137:9000"
echo ""
echo "🧪 Test with:"
echo "  curl http://159.65.134.137:9000/api/"
echo ""
