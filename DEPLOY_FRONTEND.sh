#!/bin/bash

# Frontend Deployment to VPS
set -e

VPS_IP="159.65.134.137"
VPS_USER="root"
FRONTEND_PATH="/var/www/aurapass.xyz"

echo "🎨 Frontend Deployment to VPS"
echo "=============================="
echo ""

# Step 1: Build frontend
echo "📦 Step 1: Building frontend..."
cd frontend

# Update .env.production with correct backend URL
cat > .env.production << 'EOF'
REACT_APP_BACKEND_URL=http://159.65.134.137:9000
REACT_APP_CHAIN_ID=80002
REACT_APP_BADGE_CONTRACT=0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678
REACT_APP_PASSPORT_CONTRACT=0x1112373c9954B9bbFd91eb21175699b609A1b551
REACT_APP_PROOF_REGISTRY=0x296DB144E62C8C826bffA4503Dc9Fbf29F25D44B
EOF

echo "✅ Environment configured"
echo ""

echo "🔨 Building React app..."
yarn build
echo "✅ Build complete"
echo ""

# Step 2: Create tarball
echo "📦 Step 2: Creating deployment package..."
cd build
tar -czf ../../frontend-build.tar.gz .
cd ../..
echo "✅ Package created: frontend-build.tar.gz"
echo ""

# Step 3: Upload to VPS
echo "📤 Step 3: Uploading to VPS..."
scp frontend-build.tar.gz ${VPS_USER}@${VPS_IP}:/tmp/
echo "✅ Upload complete"
echo ""

# Step 4: Deploy on VPS
echo "🔧 Step 4: Deploying on VPS..."
ssh ${VPS_USER}@${VPS_IP} << 'ENDSSH'
set -e

echo "  → Backing up old frontend..."
if [ -d /var/www/aurapass.xyz ]; then
    mv /var/www/aurapass.xyz /var/www/aurapass.xyz.backup.$(date +%Y%m%d_%H%M%S)
fi

echo "  → Creating frontend directory..."
mkdir -p /var/www/aurapass.xyz
cd /var/www/aurapass.xyz

echo "  → Extracting files..."
tar -xzf /tmp/frontend-build.tar.gz
rm /tmp/frontend-build.tar.gz

echo "  → Setting permissions..."
chown -R www-data:www-data /var/www/aurapass.xyz
chmod -R 755 /var/www/aurapass.xyz

echo "  → Configuring nginx..."
cat > /etc/nginx/sites-available/aurapass.xyz << 'NGINX_EOF'
server {
    listen 80;
    server_name aurapass.xyz www.aurapass.xyz 159.65.134.137;

    root /var/www/aurapass.xyz;
    index index.html;

    # Frontend
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Backend API proxy
    location /api/ {
        proxy_pass http://localhost:9000/api/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Static files caching
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
NGINX_EOF

echo "  → Enabling site..."
ln -sf /etc/nginx/sites-available/aurapass.xyz /etc/nginx/sites-enabled/

echo "  → Testing nginx config..."
nginx -t

echo "  → Reloading nginx..."
systemctl reload nginx

echo "  ✅ Frontend deployed successfully!"

ENDSSH

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📊 Deployment Summary:"
echo "  • Frontend: http://${VPS_IP}"
echo "  • Backend API: http://${VPS_IP}:9000"
echo "  • Nginx: Configured with API proxy"
echo ""
echo "🧪 Test URLs:"
echo "  • Homepage: http://${VPS_IP}"
echo "  • API (via proxy): http://${VPS_IP}/api/"
echo "  • API (direct): http://${VPS_IP}:9000/api/"
echo ""
echo "🔍 Debug Commands (on VPS):"
echo "  ssh ${VPS_USER}@${VPS_IP}"
echo "  nginx -t"
echo "  systemctl status nginx"
echo "  ls -la /var/www/aurapass.xyz"
echo ""

# Cleanup
rm -f frontend-build.tar.gz
echo "🎉 Done!"
