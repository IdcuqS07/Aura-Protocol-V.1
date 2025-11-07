# 🧪 Phase 2: Testing & Deployment Guide

## ✅ Prerequisites
- Backend running on port 9000
- Frontend running on port 3000
- MongoDB running
- Wallet with MATIC for deployment (optional)

---

## 🧪 PART 1: TESTING (REQUIRED)

### Step 1: Restart Backend

**Why?** New code needs to be loaded (auto-update passport function)

**How:**
```bash
# In backend terminal:
# 1. Press Ctrl+C to stop
# 2. Restart:
cd backend
source venv/bin/activate
uvicorn server:app --reload --port 9000

# Wait for: "Application startup complete"
```

### Step 2: Run Integration Test

```bash
bash test-phase2.sh
```

**Expected Output:**
```
✅ Backend is running
✅ Badge minted (passport should auto-create/update)
✅ Passport exists!
   Credit Score: 250/1000
   Badge Count: 1
✅ Passport auto-updated after badge mint!
```

### Step 3: Verify in Frontend

1. Open: http://localhost:3000/passport
2. Connect wallet
3. Should see:
   - Credit score displayed
   - Badge count = 1
   - Risk level
   - Grade

### Step 4: Test Multiple Badges

```bash
# Mint another badge (different wallet to avoid nullifier conflict)
bash test-poh.sh
```

Check passport updates:
- Badge count increases
- Credit score increases
- Risk level may change

---

## 🚀 PART 2: DEPLOYMENT (OPTIONAL)

### Option A: Deploy Contract to Polygon Amoy

#### Prerequisites:
- Wallet has MATIC (~0.1 MATIC for deployment)
- Private key in `contracts/.env`

#### Steps:

**1. Check Balance:**
```bash
cd contracts
npx hardhat run scripts/check-balance.js --network polygon-amoy
```

**2. Deploy Contract:**
```bash
npx hardhat run scripts/deploy-credit-passport.js --network polygon-amoy
```

**Expected Output:**
```
🚀 Deploying CreditPassport contract...
Deploying with account: 0xC3E...
Account balance: 0.27 MATIC
✅ CreditPassport deployed to: 0x...
🔑 Authorizing deployer as minter...
✅ Deployer authorized
📝 Deployment info saved
🎉 Deployment complete!
```

**3. Update Backend .env:**
```bash
# Add to backend/.env
CREDIT_PASSPORT_CONTRACT="0x..." # Use deployed address
```

**4. Restart Backend:**
```bash
cd backend
# Ctrl+C then restart
uvicorn server:app --reload --port 9000
```

---

### Option B: Skip Contract Deployment

**Why skip?**
- Testing phase, don't need on-chain yet
- Save gas fees
- MongoDB storage works fine for now

**What works without contract:**
- ✅ Passport creation
- ✅ Score calculation
- ✅ Badge aggregation
- ✅ Frontend display
- ❌ On-chain passport NFT

**When to deploy:**
- Production launch
- Need on-chain verification
- External dApps need to query

---

## 📊 Testing Checklist

### Backend Tests:
- [ ] Backend restarts successfully
- [ ] `/api/poh/issue` creates passport
- [ ] `/api/passport/{user_id}` returns passport
- [ ] Credit score calculated correctly
- [ ] Badge count updates

### Frontend Tests:
- [ ] `/passport` page loads
- [ ] Passport card displays
- [ ] Credit score shows
- [ ] Badge count correct
- [ ] Risk level displays

### Integration Tests:
- [ ] Mint badge → Passport created
- [ ] Mint 2nd badge → Score increases
- [ ] Badge count updates automatically
- [ ] No manual intervention needed

---

## 🐛 Troubleshooting

### Issue: "Passport not found"
**Cause:** Backend not restarted  
**Fix:** Restart backend, run test again

### Issue: Badge count = 0
**Cause:** Query not finding badges  
**Fix:** Check MongoDB badges collection

### Issue: Score not updating
**Cause:** Passport not updating after badge  
**Fix:** Check backend logs for errors

### Issue: Contract deployment fails
**Cause:** Insufficient MATIC  
**Fix:** Get MATIC from faucet: https://faucet.polygon.technology/

---

## ✅ Success Criteria

**Phase 2 Testing Complete When:**
- ✅ Backend restarts without errors
- ✅ Test script passes all steps
- ✅ Passport auto-creates after badge
- ✅ Score calculates correctly
- ✅ Frontend displays passport
- ✅ Badge count updates

**Phase 2 Deployment Complete When:**
- ✅ Contract deployed to Polygon Amoy
- ✅ Contract address in .env
- ✅ Backend can interact with contract
- ✅ On-chain passport minting works

---

## 📈 Test Results Template

```
Date: ___________
Tester: ___________

TESTING:
[ ] Backend restarted - PASS/FAIL
[ ] Integration test - PASS/FAIL
[ ] Passport created - PASS/FAIL
[ ] Score calculated - PASS/FAIL
[ ] Frontend display - PASS/FAIL

DEPLOYMENT (Optional):
[ ] Contract deployed - PASS/FAIL/SKIP
[ ] Backend updated - PASS/FAIL/SKIP
[ ] On-chain minting - PASS/FAIL/SKIP

Notes:
_________________________________
```

---

## 🎯 What's Next?

### After Testing Passes:
1. ✅ Mark Phase 2 as complete
2. Move to Phase 3 (Proof-as-a-Service API)
3. Or deploy to production

### After Deployment:
1. Verify contract on PolygonScan
2. Test on-chain passport minting
3. Update frontend to use contract
4. Deploy to production

---

## 📝 Quick Commands

```bash
# Restart backend
cd backend && source venv/bin/activate && uvicorn server:app --reload --port 9000

# Run test
bash test-phase2.sh

# Deploy contract
cd contracts && npx hardhat run scripts/deploy-credit-passport.js --network polygon-amoy

# Check MongoDB
mongosh
use aura_protocol
db.passports.find().pretty()
db.badges.find().count()
```

---

## 🎉 Completion

**When both parts done:**
- ✅ Phase 2: Credit Passport - 100% COMPLETE
- ✅ Auto-update working
- ✅ Integration tested
- ✅ Ready for production (optional: with contract)

**Achievement Unlocked:** Credit Passport System! 🏆

---

**Status:** 🟢 READY TO TEST

**Time Required:**
- Testing: 5 minutes
- Deployment: 10 minutes (optional)
- Total: 5-15 minutes
