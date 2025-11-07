#!/bin/bash

echo "🚀 Updating Frontend on VPS..."

sshpass -p '12Shaquille' ssh -o StrictHostKeyChecking=no root@103.127.132.76 "cd /root/Aura-Protocol-V.1-main && echo '📥 Pulling latest changes...' && git pull && cd frontend && echo '📦 Installing dependencies...' && yarn install && echo '🔨 Building frontend...' && yarn build && echo '♻️ Restarting frontend...' && pm2 restart frontend && echo '✅ Frontend updated successfully!' && pm2 status"
