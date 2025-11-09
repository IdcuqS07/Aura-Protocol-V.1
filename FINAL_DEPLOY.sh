#!/bin/bash

echo "🚀 AURA PROTOCOL - FINAL DEPLOYMENT TO VPS"
echo "=========================================="

# Step 1: Build Frontend
echo ""
echo "📦 Step 1: Building Frontend..."
cd frontend
yarn build

if [ $? -ne 0 ]; then
    echo "❌ Frontend build failed!"
    exit 1
fi

echo "✅ Frontend built successfully"

# Step 2: Create tarball
echo ""
echo "📦 Step 2: Creating tarball..."
tar czf build.tar.gz build/
echo "✅ Tarball created"

# Step 3: Upload to VPS
echo ""
echo "📤 Step 3: Uploading to VPS..."
scp build.tar.gz root@159.65.134.137:/tmp/

if [ $? -ne 0 ]; then
    echo "❌ Upload failed!"
    exit 1
fi

echo "✅ Upload complete"

# Step 4: Deploy on VPS
echo ""
echo "🔧 Step 4: Deploying on VPS..."
ssh root@159.65.134.137 << 'ENDSSH'
    echo "Extracting frontend..."
    cd /var/www/aurapass.xyz
    rm -rf *
    tar xzf /tmp/build.tar.gz
    mv build/* .
    rmdir build
    chown -R www-data:www-data /var/www/aurapass.xyz
    chmod -R 755 /var/www/aurapass.xyz
    
    echo "Updating backend..."
    cd /root/Aura-Protocol-V.1-main
    git pull
    
    echo "Restarting backend..."
    cd backend
    pm2 restart aura-backend
    
    echo "Reloading Nginx..."
    nginx -t && systemctl reload nginx
    
    echo "✅ Deployment complete!"
ENDSSH

# Step 5: Verify
echo ""
echo "🔍 Step 5: Verifying deployment..."
echo ""
echo "Testing backend..."
curl -s http://159.65.134.137:9000/ | head -5

echo ""
echo ""
echo "✅ DEPLOYMENT COMPLETE!"
echo ""
echo "🌐 Frontend: https://www.aurapass.xyz"
echo "🔧 Backend: http://159.65.134.137:9000"
echo "📚 API Docs: http://159.65.134.137:9000/docs"
echo ""
echo "🎉 Gelombang 2 - 100% Complete & Deployed!"
