# 🚀 START HERE - PoH Testing

## Step 1: Start Backend (Terminal 1)

```bash
cd /Users/idcuq/Documents/Akindo/Aura\ Protocol/Aura-Protocol-V.1-main
./start-backend.sh
```

**Wait for this message:**
```
INFO:     Application startup complete.
INFO:     Uvicorn running on http://0.0.0.0:9000
```

**DO NOT CLOSE THIS TERMINAL!**

---

## Step 2: Verify Backend (New Terminal)

```bash
curl http://localhost:9000/api/
```

**Expected response:**
```json
{"message":"Aura Protocol API","version":"1.0.0"}
```

---

## Step 3: Start Frontend (Terminal 2)

```bash
cd /Users/idcuq/Documents/Akindo/Aura\ Protocol/Aura-Protocol-V.1-main/frontend
yarn start
```

**Wait for:**
```
Compiled successfully!
```

---

## Step 4: Test in Browser

Open: **http://localhost:3000/proof-of-humanity**

### Test Flow:
1. ✅ Connect wallet (MetaMask)
2. ✅ Click "Continue to Enrollment" (skip OAuth for now)
3. ✅ Should see enrollment success with score

---

## 🐛 Troubleshooting

### "Failed to fetch"
**Cause:** Backend not running  
**Fix:** Go back to Terminal 1, make sure backend is running

### "Port already in use"
```bash
pkill -f "uvicorn server:app"
./start-backend.sh
```

### Backend won't start
```bash
./test-backend-start.sh
```

---

## 📊 Success Indicators

**Backend running:**
- Terminal shows "Uvicorn running on http://0.0.0.0:9000"
- `curl http://localhost:9000/api/` returns JSON

**Frontend running:**
- Browser shows PoH page
- No console errors about CORS

**PoH working:**
- Enrollment creates ID
- Score calculated (0-100)
- No "Failed to fetch" errors

---

**Keep both terminals open while testing!**
