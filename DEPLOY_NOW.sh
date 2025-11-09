#!/bin/bash

echo "╔══════════════════════════════════════════════════════════════════════════════╗"
echo "║                                                                              ║"
echo "║                    🚀 AURA PROTOCOL - DEPLOY NOW                             ║"
echo "║                                                                              ║"
echo "╚══════════════════════════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check if we're in the right directory
if [ ! -d "frontend" ] || [ ! -d "backend" ]; then
    echo -e "${RED}Error: Please run this script from the project root directory${NC}"
    exit 1
fi

echo -e "${BLUE}STEP 1: Checking Prerequisites${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check if .env exists
if [ ! -f "backend/.env" ]; then
    echo -e "${YELLOW}⚠️  backend/.env not found. Creating from template...${NC}"
    cp backend/.env.example backend/.env 2>/dev/null || echo "MONGO_URL=mongodb://localhost:27017
DB_NAME=aura_protocol
GITHUB_CLIENT_ID=
GITHUB_CLIENT_SECRET=
ALCHEMY_API_KEY=
PRIVATE_KEY=
CORS_ORIGINS=https://www.aurapass.xyz,http://localhost:3000
BADGE_CONTRACT_ADDRESS=0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678
PASSPORT_CONTRACT_ADDRESS=0x1112373c9954B9bbFd91eb21175699b609A1b551
PROOF_REGISTRY_ADDRESS=0x296DB144E62C8C826bffA4503Dc9Fbf29F25D44B" > backend/.env
fi

# Check for OAuth credentials
echo ""
echo -e "${YELLOW}Checking OAuth credentials...${NC}"
if ! grep -q "GITHUB_CLIENT_ID=." backend/.env || ! grep -q "ALCHEMY_API_KEY=." backend/.env; then
    echo -e "${RED}❌ OAuth credentials not configured!${NC}"
    echo ""
    echo "You need to setup:"
    echo "1. GitHub OAuth App: https://github.com/settings/developers"
    echo "2. Alchemy API Key: https://www.alchemy.com/"
    echo ""
    echo "Then edit: backend/.env"
    echo ""
    read -p "Do you want to edit .env now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ${EDITOR:-nano} backend/.env
    else
        echo -e "${YELLOW}Please setup credentials and run this script again${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✓ Prerequisites checked${NC}"
echo ""

echo -e "${BLUE}STEP 2: Building Frontend${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cd frontend

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "Installing dependencies..."
    yarn install
fi

echo "Building production bundle..."
yarn build

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Frontend build failed${NC}"
    exit 1
fi

echo "Creating tarball..."
cd build
tar -czf ../build.tar.gz .
cd ../..

echo -e "${GREEN}✓ Frontend built successfully${NC}"
echo ""

echo -e "${BLUE}STEP 3: Uploading to VPS${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo "Uploading frontend build to VPS..."
scp frontend/build.tar.gz root@159.65.134.137:/tmp/

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Upload failed. Check VPS connection${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Upload successful${NC}"
echo ""

echo -e "${BLUE}STEP 4: Deploying on VPS${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo "Connecting to VPS and deploying..."
ssh root@159.65.134.137 << 'ENDSSH'
    echo "📦 Updating backend..."
    cd /root/Aura-Protocol-V.1-main
    git pull origin main
    
    echo "🔄 Restarting backend..."
    systemctl restart aura-backend
    sleep 3
    
    if systemctl is-active --quiet aura-backend; then
        echo "✅ Backend running"
    else
        echo "❌ Backend failed to start"
        systemctl status aura-backend --no-pager
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
        echo "✅ Nginx reloaded"
    else
        echo "❌ Nginx reload failed"
    fi
    
    echo ""
    echo "🧹 Cleaning up..."
    rm -f /tmp/build.tar.gz
    
    echo ""
    echo "✅ Deployment complete!"
ENDSSH

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Deployment failed${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}STEP 5: Verification${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo "Testing backend API..."
BACKEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://www.aurapass.xyz/api/)

if [ "$BACKEND_STATUS" = "200" ]; then
    echo -e "${GREEN}✓ Backend API: OK (HTTP 200)${NC}"
else
    echo -e "${YELLOW}⚠ Backend API: HTTP $BACKEND_STATUS${NC}"
fi

echo "Testing frontend..."
FRONTEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://www.aurapass.xyz/)

if [ "$FRONTEND_STATUS" = "200" ]; then
    echo -e "${GREEN}✓ Frontend: OK (HTTP 200)${NC}"
else
    echo -e "${YELLOW}⚠ Frontend: HTTP $FRONTEND_STATUS${NC}"
fi

echo ""
echo "╔══════════════════════════════════════════════════════════════════════════════╗"
echo "║                                                                              ║"
echo "║                         🎉 DEPLOYMENT COMPLETE!                              ║"
echo "║                                                                              ║"
echo "╚══════════════════════════════════════════════════════════════════════════════╝"
echo ""
echo -e "${GREEN}✅ Aura Protocol is now live!${NC}"
echo ""
echo "📱 Application: https://www.aurapass.xyz/"
echo "🔧 Backend API: https://www.aurapass.xyz/api/"
echo "📊 Analytics: https://www.aurapass.xyz/api/analytics"
echo ""
echo "🧪 Next Steps:"
echo "1. Visit https://www.aurapass.xyz/"
echo "2. Connect your MetaMask wallet"
echo "3. Test badge minting"
echo "4. Test credit passport"
echo "5. Test AI risk oracle"
echo ""
echo "📊 Monitor logs:"
echo "  ssh root@159.65.134.137"
echo "  tail -f /root/Aura-Protocol-V.1-main/backend/backend.log"
echo ""
echo "🎉 Ready for user testing!"
echo ""
