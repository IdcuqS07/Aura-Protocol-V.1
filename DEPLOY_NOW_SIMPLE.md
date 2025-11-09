# 🚀 Deploy Now - Simple Guide

## Current Status
- ✅ Frontend built (3.9MB)
- ✅ All code ready
- ⏳ Backend not responding on VPS
- ⏳ Need to deploy

## Quick Deploy

### 1. SSH to VPS
```bash
ssh root@159.65.134.137
```

### 2. Start Backend
```bash
cd /root/Aura-Protocol-V.1-main/backend
pm2 restart aura-backend || pm2 start server.py --name aura-backend --interpreter python3
pm2 logs aura-backend --lines 20
```

### 3. Deploy Frontend
```bash
cd /root/Aura-Protocol-V.1-main
git pull
cd frontend
yarn install
yarn build
```

### 4. Test
```bash
curl http://159.65.134.137:9000/api/
```

## Done! ✅
Visit: https://www.aurapass.xyz
