# 🚀 DEPLOY CREDIT PASSPORT - QUICK GUIDE

**Time**: 5 minutes  
**Status**: Ready to deploy

---

## 📋 STEP-BY-STEP

### 1️⃣ SSH ke VPS
```bash
ssh root@your-vps-ip
```

### 2️⃣ Update Backend
```bash
cd /var/www/aura-backend-new
git pull origin main
/var/www/restart-backend.sh
```

**Expected output**:
```
✅ Stopped PM2 process
✅ Killed all uvicorn processes
✅ Started new backend
✅ Backend running on port 9000
```

### 3️⃣ Update Frontend
```bash
cd /var/www/aura-frontend
git pull origin main
yarn install
yarn build
sudo systemctl restart nginx
```

**Expected output**:
```
✅ Dependencies installed
✅ Build complete
✅ Nginx restarted
```

### 4️⃣ Verify Backend
```bash
curl http://localhost:9000/api/passport/score/0x96eb6DcBb03cE5818b9dF1446c1df378eb98De15
```

**Expected response**:
```json
{
  "success": true,
  "poh_score": 0,
  "badge_count": 0,
  "credit_score": 0
}
```

### 5️⃣ Test Frontend
```
1. Open browser: https://www.aurapass.xyz/passport
2. Connect wallet
3. Should see "Mint Passport (Pay Gas)" button
```

---

## ✅ VERIFICATION

### Check Backend Logs
```bash
pm2 logs aura-backend --lines 50
```

Look for:
- ✅ No errors
- ✅ "Application startup complete"
- ✅ Listening on port 9000

### Check Frontend
```bash
curl -I https://www.aurapass.xyz
```

Look for:
- ✅ HTTP 200 OK
- ✅ No 404 errors

---

## 🧪 TEST MINTING

### 1. Visit Passport Page
```
https://www.aurapass.xyz/passport
```

### 2. Connect Wallet
- Click "Connect Wallet"
- Approve MetaMask

### 3. Mint Passport
- Click "Mint Passport (Pay Gas)"
- Confirm dialog (shows PoH score, badges, estimated score)
- Approve MetaMask transaction
- Wait for confirmation
- Passport should appear

---

## 🔍 TROUBLESHOOTING

### Backend not starting?
```bash
# Check port 9000
lsof -i :9000

# Kill if needed
kill -9 $(lsof -t -i:9000)

# Restart
/var/www/restart-backend.sh
```

### Frontend not updating?
```bash
cd /var/www/aura-frontend
rm -rf build node_modules
yarn install
yarn build
sudo systemctl restart nginx
```

### Contract not working?
```bash
# Check contract address in frontend
grep -r "0x1112373c9954B9bbFd91eb21175699b609A1b551" /var/www/aura-frontend/src/
```

---

## 📊 MONITORING

### Watch Backend Logs
```bash
pm2 logs aura-backend --lines 100 --raw
```

### Watch Nginx Logs
```bash
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log
```

### Check PM2 Status
```bash
pm2 status
pm2 monit
```

---

## 🎯 SUCCESS CRITERIA

- ✅ Backend responds to `/api/passport/score/{address}`
- ✅ Frontend shows "Mint Passport" button
- ✅ MetaMask popup appears on click
- ✅ Transaction succeeds on Polygon Amoy
- ✅ Passport appears after minting
- ✅ No console errors

---

## 🚨 ROLLBACK (if needed)

```bash
# Backend
cd /var/www/aura-backend-new
git reset --hard HEAD~1
/var/www/restart-backend.sh

# Frontend
cd /var/www/aura-frontend
git reset --hard HEAD~1
yarn build
sudo systemctl restart nginx
```

---

## 📝 COMMANDS SUMMARY

```bash
# Full deployment (copy-paste)
ssh root@your-vps-ip << 'EOF'
cd /var/www/aura-backend-new && git pull origin main && /var/www/restart-backend.sh
cd /var/www/aura-frontend && git pull origin main && yarn install && yarn build && sudo systemctl restart nginx
echo "✅ Deployment complete!"
EOF
```

---

**Ready? Copy commands above and deploy!** 🚀
