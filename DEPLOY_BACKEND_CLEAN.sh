#!/bin/bash

# Clean Backend Deployment to VPS
# This script will deploy backend from scratch

set -e  # Exit on error

VPS_IP="159.65.134.137"
VPS_USER="root"
DEPLOY_PATH="/var/www/aura-backend-clean"

echo "🚀 Clean Backend Deployment to VPS"
echo "=================================="
echo ""

# Step 1: Create deployment package
echo "📦 Step 1: Creating deployment package..."
cd backend
tar -czf ../backend-deploy.tar.gz \
  server.py \
  poh_routes.py \
  passport_routes.py \
  oracle_routes.py \
  public_api_routes.py \
  graph_routes.py \
  credit_scoring.py \
  ai_risk_oracle.py \
  github_service.py \
  twitter_service.py \
  onchain_service.py \
  polygon_id_service.py \
  api_key_auth.py \
  blockchain.py \
  proof_service.py \
  graph_client.py \
  graph_cache.py \
  waitlist.py \
  requirements.txt \
  .env
cd ..
echo "✅ Package created: backend-deploy.tar.gz"
echo ""

# Step 2: Upload to VPS
echo "📤 Step 2: Uploading to VPS..."
scp backend-deploy.tar.gz ${VPS_USER}@${VPS_IP}:/tmp/
echo "✅ Upload complete"
echo ""

# Step 3: Deploy on VPS
echo "🔧 Step 3: Deploying on VPS..."
ssh ${VPS_USER}@${VPS_IP} << 'ENDSSH'
set -e

echo "  → Stopping old backend..."
pm2 delete all 2>/dev/null || true

echo "  → Creating clean directory..."
rm -rf /var/www/aura-backend-clean
mkdir -p /var/www/aura-backend-clean
cd /var/www/aura-backend-clean

echo "  → Extracting files..."
tar -xzf /tmp/backend-deploy.tar.gz
rm /tmp/backend-deploy.tar.gz

echo "  → Creating virtual environment..."
python3 -m venv venv
source venv/bin/activate

echo "  → Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

echo "  → Starting backend with PM2..."
pm2 start venv/bin/uvicorn --name aura-backend -- server:app --host 0.0.0.0 --port 9000
pm2 save

echo "  → Waiting for backend to start..."
sleep 5

echo "  → Testing backend..."
curl -s http://localhost:9000/api/analytics > /dev/null && echo "  ✅ Backend is responding" || echo "  ❌ Backend not responding"

echo "  → Testing PoH endpoint..."
curl -s -X POST http://localhost:9000/api/poh/enroll \
  -H "Content-Type: application/json" \
  -d '{"user_id":"test","wallet_address":"0x123"}' | grep -q "enrollment_id\|detail" && echo "  ✅ PoH endpoint responding" || echo "  ⚠️  PoH endpoint may need OAuth credentials"

ENDSSH

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📊 Deployment Summary:"
echo "  • Location: ${DEPLOY_PATH}"
echo "  • Backend: http://${VPS_IP}:9000"
echo "  • PM2 Status: pm2 status"
echo ""
echo "🧪 Test Commands:"
echo "  curl http://${VPS_IP}:9000/api/analytics"
echo "  curl -X POST http://${VPS_IP}:9000/api/poh/enroll -H 'Content-Type: application/json' -d '{\"user_id\":\"test\",\"wallet_address\":\"0x123\"}'"
echo ""
echo "🔍 Debug Commands (on VPS):"
echo "  ssh ${VPS_USER}@${VPS_IP}"
echo "  pm2 logs aura-backend"
echo "  pm2 status"
echo ""

# Cleanup
rm -f backend-deploy.tar.gz
echo "🎉 Done!"
