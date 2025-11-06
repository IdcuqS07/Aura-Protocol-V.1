#!/bin/bash

VPS_IP="159.65.134.137"
VPS_USER="root"
VPS_PASSWORD="12Shaquille"
BACKEND_DIR="/var/www/aura-backend"

echo "📦 Packaging backend..."
cd backend
tar -czf ../backend.tar.gz --exclude='venv' --exclude='__pycache__' --exclude='*.pyc' .
cd ..

echo "📤 Uploading to VPS..."
sshpass -p "$VPS_PASSWORD" scp backend.tar.gz $VPS_USER@$VPS_IP:/tmp/

echo "🚀 Deploying on VPS..."
sshpass -p "$VPS_PASSWORD" ssh $VPS_USER@$VPS_IP << 'EOF'
  # Create directory
  mkdir -p /var/www/aura-backend
  cd /var/www/aura-backend
  
  # Extract
  tar -xzf /tmp/backend.tar.gz
  rm /tmp/backend.tar.gz
  
  # Setup Python venv
  python3 -m venv venv
  source venv/bin/activate
  pip install -r requirements.txt
  
  # Create systemd service
  cat > /etc/systemd/system/aura-backend.service << 'SERVICE'
[Unit]
Description=Aura Protocol Backend
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/var/www/aura-backend
Environment="PATH=/var/www/aura-backend/venv/bin"
ExecStart=/var/www/aura-backend/venv/bin/uvicorn server:app --host 0.0.0.0 --port 9000
Restart=always

[Install]
WantedBy=multi-user.target
SERVICE
  
  # Start service
  systemctl daemon-reload
  systemctl enable aura-backend
  systemctl restart aura-backend
  
  echo "✅ Backend deployed!"
EOF

rm backend.tar.gz
echo "🎉 Deployment complete!"
echo "Backend running at: http://$VPS_IP:9000"
