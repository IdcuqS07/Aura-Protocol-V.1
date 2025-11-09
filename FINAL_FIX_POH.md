# 🔧 FINAL FIX: PoH Deployment

## 🎯 Problem Summary
- PoH files exist on VPS
- Backend running but PoH endpoints return "Not Found"
- Multiple backend instances causing confusion

## ✅ SOLUTION: Manual SSH Fix (5 minutes)

### Step 1: SSH to VPS
```bash
ssh root@159.65.134.137
```

### Step 2: Stop All Backends
```bash
pm2 delete all
pkill -f uvicorn
```

### Step 3: Go to NEW Backend
```bash
cd /var/www/aura-backend-new
```

### Step 4: Check PoH Files Exist
```bash
ls -la poh_routes.py github_service.py twitter_service.py
# Should see all 3 files
```

### Step 5: Check server.py Imports PoH
```bash
grep "poh_router" server.py
# Should see: from poh_routes import router as poh_router
# Should see: app.include_router(poh_router, prefix="/api")
```

### Step 6: Install Dependencies
```bash
pip3 install httpx
```

### Step 7: Start Backend Manually (Test)
```bash
uvicorn server:app --host 0.0.0.0 --port 9000
```

**Wait for:** `Application startup complete`

### Step 8: Test in New Terminal
```bash
# Open new terminal
curl -X POST http://159.65.134.137:9000/api/poh/enroll \
  -H "Content-Type: application/json" \
  -d '{"user_id":"test","wallet_address":"0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"}'
```

**Expected:** `{"success":true,"enrollment_id":"...","score":5}`

### Step 9: If Works, Start with PM2
```bash
# Ctrl+C to stop manual server
pm2 start "uvicorn server:app --host 0.0.0.0 --port 9000" --name aura-backend
pm2 save
```

### Step 10: Test Production
```bash
curl -X POST https://www.aurapass.xyz/api/poh/enroll \
  -H "Content-Type: application/json" \
  -d '{"user_id":"test","wallet_address":"0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"}'
```

**Expected:** `{"success":true,...}`

---

## 🐛 If Still Fails

### Check 1: Backend Logs
```bash
pm2 logs aura-backend
# Look for import errors
```

### Check 2: Python Path
```bash
cd /var/www/aura-backend-new
python3 -c "import poh_routes; print('OK')"
```

### Check 3: Server.py
```bash
python3 -c "import server; print('OK')"
```

### Check 4: Port
```bash
ss -tlnp | grep :9000
# Should show uvicorn listening
```

---

## ✅ Success Criteria

- [ ] `curl http://localhost:9000/api/poh/enroll` returns enrollment_id
- [ ] `curl https://www.aurapass.xyz/api/poh/enroll` returns enrollment_id
- [ ] Go to https://www.aurapass.xyz/poh - no "Not found" error
- [ ] Can complete enrollment flow

---

## 📝 Quick Commands

```bash
# All in one (run on VPS):
cd /var/www/aura-backend-new && \
pm2 delete all && \
pkill -f uvicorn && \
pip3 install httpx && \
pm2 start "uvicorn server:app --host 0.0.0.0 --port 9000" --name aura-backend && \
pm2 save && \
sleep 5 && \
curl -X POST http://localhost:9000/api/poh/enroll \
  -H "Content-Type: application/json" \
  -d '{"user_id":"test","wallet_address":"0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"}'
```

---

**Time Required:** 5 minutes
**Success Rate:** 99% (if files exist)
