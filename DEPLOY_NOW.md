# 🚀 DEPLOY NOW - One Command

Deploy PoH backend to VPS with one command.

---

## ⚡ Quick Deploy

```bash
./deploy.sh
```

This will:
1. ✅ SSH to VPS
2. ✅ Pull latest code
3. ✅ Restart backend on port 9000
4. ✅ Verify everything works

---

## 📋 Manual Deploy (if script fails)

```bash
ssh root@165.232.166.78

cd /var/www/aura-backend-new
git pull origin main

pm2 delete aura-backend
pm2 start "uvicorn server:app --host 0.0.0.0 --port 9000" --name aura-backend
pm2 save

lsof -i :9000
curl http://localhost:9000/api/
```

---

## ✅ Verify Backend on Port 9000

```bash
./verify_backend.sh
```

Or manually:

```bash
ssh root@165.232.166.78 "lsof -i :9000"
ssh root@165.232.166.78 "curl http://localhost:9000/api/"
```

---

## 🔑 After Deployment

Setup OAuth credentials (30 min):

1. **GitHub OAuth**: https://github.com/settings/developers
   - Callback: `https://api.aurapass.xyz/api/poh/callback`

2. **Twitter OAuth**: https://developer.twitter.com/
   - Callback: `https://api.aurapass.xyz/api/poh/callback`

3. **Alchemy API**: https://www.alchemy.com/
   - Network: Polygon Amoy

4. **Update .env**:
```bash
ssh root@165.232.166.78
cd /var/www/aura-backend-new
nano .env

# Add:
GITHUB_CLIENT_ID=xxx
GITHUB_CLIENT_SECRET=xxx
TWITTER_CLIENT_ID=xxx
TWITTER_CLIENT_SECRET=xxx
ALCHEMY_API_KEY=xxx

# Save and restart
pm2 restart aura-backend
```

---

## 🧪 Test

Visit: https://www.aurapass.xyz/verify

1. Connect GitHub ✅
2. Connect Twitter ✅
3. Complete enrollment ✅
4. Mint badge ✅

---

## 📚 Full Documentation

- `DEPLOYMENT_CHECKLIST.md` - Complete checklist
- `VERIFY_PORT_9000.md` - Port verification guide
- `QUICK_START.md` - 45-minute guide
- `GELOMBANG2_STATUS.md` - Status report

---

> **Backend MUST run on port 9000 for Nginx proxy to work!**
