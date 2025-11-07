# ⚡ Quick: Run Phase 2 Test

## 🎯 Goal: Test Phase 2 in 5 minutes

---

## Step 1: Restart Backend (2 min)

**In backend terminal:**
```bash
# Press Ctrl+C

# Then run:
cd backend
source venv/bin/activate
uvicorn server:app --reload --port 9000
```

**Wait for:** `Application startup complete`

---

## Step 2: Run Test (1 min)

**In new terminal:**
```bash
cd "/Users/idcuq/Documents/Akindo/Aura Protocol/Aura-Protocol-V.1-main"
bash test-phase2.sh
```

---

## Step 3: Check Results (2 min)

**Expected:**
```
✅ Badge minted
✅ Passport exists!
   Credit Score: 250/1000
   Badge Count: 1
✅ Passport auto-updated!
```

**If PASS:**
- Phase 2 complete! 🎉
- Go to http://localhost:3000/passport
- See your credit passport

**If FAIL:**
- Check backend logs
- Check MongoDB: `mongosh` → `use aura_protocol` → `db.passports.find()`
- Run test again

---

## Optional: Deploy Contract (10 min)

**Only if you want on-chain passport:**

```bash
cd contracts
npx hardhat run scripts/deploy-credit-passport.js --network polygon-amoy
```

**Then update backend/.env:**
```
CREDIT_PASSPORT_CONTRACT="0x..." # deployed address
```

---

## ✅ Done!

Phase 2: Credit Passport - COMPLETE! 🏆

**What works:**
- ✅ Auto-create passport after badge
- ✅ Auto-update score
- ✅ Badge aggregation
- ✅ Risk assessment

**Next:** Phase 3 or Production Deployment
