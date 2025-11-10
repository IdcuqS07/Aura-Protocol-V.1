#!/bin/bash

# Aura Protocol - Frontend Deployment Script
# Deploy to VPS: 103.127.132.132

set -e

echo "🚀 Starting Aura Protocol Frontend Deployment..."

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration
VPS_HOST="103.127.132.132"
VPS_USER="root"
VPS_PATH="/var/www/aurapass.xyz"
BUILD_FILE="build.tar.gz"

# Step 1: Build frontend
echo -e "${BLUE}📦 Building frontend...${NC}"
cd frontend
yarn build

# Step 2: Compress build
echo -e "${BLUE}🗜️  Compressing build...${NC}"
tar -czf $BUILD_FILE -C build .

# Step 3: Upload to VPS
echo -e "${BLUE}📤 Uploading to VPS...${NC}"
scp $BUILD_FILE $VPS_USER@$VPS_HOST:/tmp/

# Step 4: Extract on VPS
echo -e "${BLUE}📂 Extracting on VPS...${NC}"
ssh $VPS_USER@$VPS_HOST << 'ENDSSH'
cd /var/www/aurapass.xyz
rm -rf *
tar -xzf /tmp/build.tar.gz
chown -R www-data:www-data /var/www/aurapass.xyz
chmod -R 755 /var/www/aurapass.xyz
rm /tmp/build.tar.gz
ENDSSH

# Step 5: Reload Nginx
echo -e "${BLUE}🔄 Reloading Nginx...${NC}"
ssh $VPS_USER@$VPS_HOST "nginx -t && systemctl reload nginx"

# Cleanup
echo -e "${BLUE}🧹 Cleaning up...${NC}"
rm $BUILD_FILE

echo -e "${GREEN}✅ Deployment Complete!${NC}"
echo -e "${GREEN}🌐 Visit: https://www.aurapass.xyz${NC}"
