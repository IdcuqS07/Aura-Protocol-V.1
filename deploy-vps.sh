#!/bin/bash

echo "🚀 Deploying Aura Protocol to VPS..."

# Build frontend
echo "📦 Building frontend..."
cd frontend
yarn install
yarn build

# Create deployment package
echo "📦 Creating deployment package..."
cd build
tar -czf ../../aura-frontend.tar.gz .
cd ../..

# Upload to VPS
echo "📤 Uploading to VPS..."
echo "Enter VPS password when prompted:"
scp -o PreferredAuthentications=password aura-frontend.tar.gz root@159.65.134.137:/tmp/

# Deploy on VPS
echo "🔧 Deploying on VPS..."
echo "Enter VPS password again:"
ssh -o PreferredAuthentications=password -t root@159.65.134.137 << 'EOF'
  # Create directory
  sudo mkdir -p /var/www/aura-frontend
  
  # Extract files
  sudo tar -xzf /tmp/aura-frontend.tar.gz -C /var/www/aura-frontend
  
  # Set permissions
  sudo chown -R www-data:www-data /var/www/aura-frontend
  
  # Create Nginx config
  sudo tee /etc/nginx/sites-available/aura > /dev/null << 'NGINX'
server {
    listen 80;
    server_name aurapass.xyz www.aurapass.xyz;
    
    root /var/www/aura-frontend;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    location /api {
        proxy_pass http://localhost:9000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
NGINX
  
  # Enable site
  sudo ln -sf /etc/nginx/sites-available/aura /etc/nginx/sites-enabled/
  
  # Test and reload Nginx
  sudo nginx -t && sudo systemctl reload nginx
  
  # Cleanup
  rm /tmp/aura-frontend.tar.gz
  
  echo "✅ Deployment complete!"
EOF

# Cleanup local
rm aura-frontend.tar.gz

echo "🎉 Frontend deployed to http://aurapass.xyz"
echo "🔒 Setup SSL with: ssh root@159.65.134.137 'certbot --nginx -d aurapass.xyz -d www.aurapass.xyz'"
