#!/bin/bash

echo "🚀 Deploying Aura Protocol Backend to VPS..."
echo ""

# SSH and execute deployment commands
ssh root@165.232.166.78 << 'ENDSSH'
    echo "📂 Navigating to backend directory..."
    cd /var/www/aura-backend-new
    
    echo "💾 Backing up current server.py..."
    cp server.py server.py.backup
    
    echo "📥 Pulling latest code..."
    git pull origin main
    
    echo "✅ Verifying files exist..."
    ls -la poh_routes.py github_service.py twitter_service.py onchain_service.py polygon_id_service.py
    
    echo "🔄 Restarting backend on port 9000..."
    pm2 delete aura-backend
    pm2 start "uvicorn server:app --host 0.0.0.0 --port 9000" --name aura-backend
    pm2 save
    
    echo "🔍 Verifying port 9000..."
    lsof -i :9000
    
    echo "📊 PM2 Status..."
    pm2 status
    
    echo "🧪 Testing API..."
    curl -s http://localhost:9000/api/
    echo ""
    
    echo "🧪 Testing PoH endpoint..."
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:9000/api/poh/enroll)
    echo "PoH endpoint returned: $HTTP_CODE (should be 422, not 404)"
    
    echo ""
    echo "✅ Deployment complete!"
    echo ""
    echo "📋 Next steps:"
    echo "1. Setup OAuth credentials (see DEPLOYMENT_CHECKLIST.md)"
    echo "2. Test PoH flow at https://www.aurapass.xyz/verify"
ENDSSH

echo ""
echo "🎉 Done! Backend deployed and running on port 9000"
