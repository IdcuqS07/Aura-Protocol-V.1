#!/bin/bash
sshpass -p "12Shaquille" scp backend/server.py backend/waitlist.py backend/.env root@159.65.134.137:/var/www/aura-backend/
sshpass -p "12Shaquille" ssh root@159.65.134.137 << 'EOF'
pkill -9 -f "uvicorn.*9000"
sleep 2
cd /var/www/aura-backend
source venv/bin/activate
nohup uvicorn server:app --host 0.0.0.0 --port 9000 > backend.log 2>&1 &
sleep 3
curl -s http://localhost:9000/api/waitlist
EOF
