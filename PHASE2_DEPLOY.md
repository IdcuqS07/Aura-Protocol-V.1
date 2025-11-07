# 🚀 PHASE 2: Credit Passport Deployment

## Prerequisites

✅ Phase 1 complete (PoH working)  
✅ Wallet with MATIC on Polygon Amoy  
✅ Private key in `contracts/.env`

---

## Step 1: Deploy Smart Contract

```bash
cd /Users/idcuq/Documents/Akindo/Aura\ Protocol/Aura-Protocol-V.1-main
./deploy-passport.sh
```

**Expected output:**
```
Deploying CreditPassport...
CreditPassport deployed to: 0x...
```

**Copy the contract address!**

---

## Step 2: Update Backend Config

Edit `backend/.env`:
```bash
CREDIT_PASSPORT_CONTRACT=0xYOUR_NEW_CONTRACT_ADDRESS
```

---

## Step 3: Restart Backend

```bash
# Terminal 1
pkill -f "uvicorn server:app"
./start-backend.sh
```

---

## Step 4: Test Credit Passport

### Browser Console:
```javascript
// After completing PoH enrollment
fetch('http://localhost:9000/api/passport/create', {
  method: 'POST',
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify({
    wallet_address: 'YOUR_WALLET_ADDRESS'
  })
}).then(r => r.json()).then(console.log)
```

**Expected:**
```json
{
  "success": true,
  "passport_id": "PASS-...",
  "credit_score": 650,
  "grade": "B",
  "risk_level": "medium"
}
```

---

## Step 5: View Passport in Frontend

Open: **http://localhost:3000/credit-passport**

Should show:
- ✅ Credit Score (0-1000)
- ✅ Grade (S/A/B/C/D)
- ✅ Risk Level
- ✅ Badge count
- ✅ PoH score

---

## Verification

### Check MongoDB:
```bash
mongosh aura_protocol
db.passports.find().pretty()
```

### Check Contract on PolygonScan:
```
https://amoy.polygonscan.com/address/YOUR_CONTRACT_ADDRESS
```

---

## Success Criteria

- [ ] Contract deployed to Amoy
- [ ] Backend updated with contract address
- [ ] Passport creation working
- [ ] Score calculation correct (0-1000)
- [ ] Frontend displays passport
- [ ] MongoDB has passport data

---

**Next: Phase 3 - Proof-as-a-Service API**
