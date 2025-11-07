# 🧪 QUICK TEST GUIDE - PoH

## ⚡ Quick Start (2 Terminals)

### Terminal 1 - Backend:
```bash
cd /Users/idcuq/Documents/Akindo/Aura\ Protocol/Aura-Protocol-V.1-main
./start-backend.sh
```

**Expected output:**
```
INFO:     Uvicorn running on http://0.0.0.0:9000
INFO:     Application startup complete.
```

### Terminal 2 - Frontend:
```bash
cd /Users/idcuq/Documents/Akindo/Aura\ Protocol/Aura-Protocol-V.1-main/frontend
yarn start
```

**Expected output:**
```
Compiled successfully!
Local: http://localhost:3000
```

---

## ✅ Test Checklist

### 1. Backend Health Check:
```bash
curl http://localhost:9000/api/
```
**Expected:** `{"message":"Aura Protocol API",...}`

### 2. Frontend Access:
- Open: http://localhost:3000/proof-of-humanity
- Should see: "Proof of Humanity" page with 4 steps

### 3. PoH Flow Test:

**Step 1 - Connect Wallet:**
- Click "Connect Wallet" (top right)
- Connect MetaMask
- ✅ Address should appear

**Step 2 - OAuth (Optional for now):**
- Skip GitHub/Twitter for now
- Click "Continue to Enrollment"

**Step 3 - Enrollment:**
- Should call `/api/poh/enroll`
- ✅ If error: Check backend logs
- ✅ If success: Score appears (0-100)

**Step 4 - Generate Proof:**
- Click "Generate ZK Proof"
- ✅ Proof hash generated

**Step 5 - Mint Badge:**
- Click "Mint Soulbound Badge"
- ✅ Badge minted on-chain

---

## 🐛 Common Errors

### Error: "Failed to fetch"
**Cause:** Backend not running
**Fix:** 
```bash
./start-backend.sh
```

### Error: "Enrollment failed"
**Cause:** Missing OAuth codes
**Fix:** For testing, backend should work without OAuth

### Error: "Port 9000 already in use"
**Fix:**
```bash
pkill -f "uvicorn server:app"
./start-backend.sh
```

---

## 📊 Expected Results

After successful test:
- ✅ Enrollment ID created
- ✅ Score calculated (0-100)
- ✅ Proof generated
- ✅ Badge minted
- ✅ Passport auto-created/updated

---

## 🔍 Debug Commands

**Check backend logs:**
```bash
tail -f backend/backend.log
```

**Check MongoDB data:**
```bash
mongosh aura_protocol
db.enrollments.find().pretty()
db.badges.find().pretty()
db.passports.find().pretty()
```

**Test API directly:**
```bash
curl -X POST http://localhost:9000/api/poh/enroll \
  -H "Content-Type: application/json" \
  -d '{"user_id":"test","wallet_address":"0x123"}'
```

---

**Need help? Check backend terminal for error logs!**
