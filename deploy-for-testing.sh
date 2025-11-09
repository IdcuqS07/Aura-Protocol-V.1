#!/bin/bash

echo "🚀 AURA PROTOCOL - USER TESTING DEPLOYMENT"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# VPS details
VPS_HOST="103.127.132.132"
VPS_USER="root"
VPS_PATH="/root/Aura-Protocol-V.1-main"
WEB_PATH="/var/www/aurapass.xyz"

echo -e "${BLUE}Step 1: Building Frontend${NC}"
echo "-------------------------------------------"
cd frontend

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}Installing dependencies...${NC}"
    yarn install
fi

# Build frontend
echo "Building production bundle..."
yarn build

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Frontend build successful${NC}"
else
    echo -e "${RED}✗ Frontend build failed${NC}"
    exit 1
fi

# Create tarball
echo "Creating tarball..."
cd build
tar -czf ../build.tar.gz .
cd ..

echo -e "${GREEN}✓ Tarball created: build.tar.gz${NC}"
echo ""

echo -e "${BLUE}Step 2: Uploading to VPS${NC}"
echo "-------------------------------------------"
echo "Uploading frontend build..."
scp build.tar.gz ${VPS_USER}@${VPS_HOST}:/tmp/

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Upload successful${NC}"
else
    echo -e "${RED}✗ Upload failed${NC}"
    exit 1
fi
echo ""

echo -e "${BLUE}Step 3: Deploying on VPS${NC}"
echo "-------------------------------------------"
ssh ${VPS_USER}@${VPS_HOST} << 'ENDSSH'
    echo "📦 Updating backend code..."
    cd /root/Aura-Protocol-V.1-main
    git pull origin main
    
    echo "🔄 Restarting backend service..."
    systemctl restart aura-backend
    sleep 2
    
    if systemctl is-active --quiet aura-backend; then
        echo "✅ Backend service running"
    else
        echo "❌ Backend service failed to start"
        systemctl status aura-backend
    fi
    
    echo ""
    echo "🌐 Deploying frontend..."
    cd /var/www/aurapass.xyz
    rm -rf *
    tar -xzf /tmp/build.tar.gz
    chown -R www-data:www-data .
    chmod -R 755 .
    
    echo "🔄 Reloading nginx..."
    nginx -t && systemctl reload nginx
    
    if [ $? -eq 0 ]; then
        echo "✅ Nginx reloaded successfully"
    else
        echo "❌ Nginx reload failed"
    fi
    
    echo ""
    echo "🧹 Cleaning up..."
    rm -f /tmp/build.tar.gz
ENDSSH

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Deployment successful${NC}"
else
    echo -e "${RED}✗ Deployment failed${NC}"
    exit 1
fi
echo ""

echo -e "${BLUE}Step 4: Verification${NC}"
echo "-------------------------------------------"
echo "Testing backend API..."
BACKEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://www.aurapass.xyz/api/)

if [ "$BACKEND_STATUS" = "200" ]; then
    echo -e "${GREEN}✓ Backend API responding (HTTP 200)${NC}"
else
    echo -e "${YELLOW}⚠ Backend API status: HTTP $BACKEND_STATUS${NC}"
fi

echo "Testing frontend..."
FRONTEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://www.aurapass.xyz/)

if [ "$FRONTEND_STATUS" = "200" ]; then
    echo -e "${GREEN}✓ Frontend responding (HTTP 200)${NC}"
else
    echo -e "${YELLOW}⚠ Frontend status: HTTP $FRONTEND_STATUS${NC}"
fi

echo ""
echo "=========================================="
echo -e "${GREEN}🎉 DEPLOYMENT COMPLETE!${NC}"
echo "=========================================="
echo ""
echo "📱 Application URL: https://www.aurapass.xyz/"
echo "🔧 API Endpoint: https://www.aurapass.xyz/api/"
echo "📊 Analytics: https://www.aurapass.xyz/api/analytics"
echo ""
echo "🧪 USER TESTING READY!"
echo ""
echo "Next steps:"
echo "1. Visit https://www.aurapass.xyz/"
echo "2. Connect MetaMask wallet"
echo "3. Test badge minting"
echo "4. Test credit passport"
echo "5. Test AI risk oracle"
echo ""
echo "Monitor logs:"
echo "  ssh ${VPS_USER}@${VPS_HOST}"
echo "  tail -f ${VPS_PATH}/backend/backend.log"
echo ""
