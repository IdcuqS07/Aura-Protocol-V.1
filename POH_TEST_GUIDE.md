# 🧪 Proof of Humanity - Testing Guide

## Prerequisites
- ✅ Backend running: http://localhost:9000
- ✅ Frontend running: http://localhost:3000
- ✅ MongoDB running
- ✅ Wallet connected (MetaMask)

---

## Test Flow

### 1️⃣ Access PoH Page
1. Go to http://localhost:3000/verify
2. Click **"Verify with Proof of Humanity"**
3. Should redirect to http://localhost:3000/poh

**Expected:**
- ✅ Page loads with 4-step progress bar
- ✅ Step 1 is active (blue)
- ✅ Shows "Connect GitHub" and "Connect Twitter" buttons

---

### 2️⃣ Test Without OAuth (Quick Test)

**Option A: Skip OAuth (For Testing)**

Open browser console and run:
```javascript
// Simulate enrollment without OAuth
fetch('http://localhost:9000/api/poh/enroll', {
  method: 'POST',
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify({
    user_id: '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1',
    wallet_address: '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1',
    github_code: null,
    twitter_code: null
  })
})
.then(r => r.json())
.then(d => console.log('Enrollment:', d))
```

**Expected Response:**
```json
{
  "success": true,
  "enrollment_id": "uuid-here",
  "score": 30,
  "verification_level": "low",
  "attestations": {...}
}
```

---

### 3️⃣ Test Proof Generation

```javascript
// Use enrollment_id from previous step
const enrollmentId = 'paste-enrollment-id-here';

fetch('http://localhost:9000/api/poh/prove', {
  method: 'POST',
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify({
    enrollment_id: enrollmentId,
    identity_secret: '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1'
  })
})
.then(r => r.json())
.then(d => console.log('Proof:', d))
```

**Expected Response:**
```json
{
  "success": true,
  "proof_hash": "0x...",
  "nullifier": "0x...",
  "public_signals": [30, 0],
  "credential_id": "urn:uuid:..."
}
```

---

### 4️⃣ Test Badge Issuance

```javascript
// Use proof_hash and nullifier from previous step
const proofHash = 'paste-proof-hash-here';
const nullifier = 'paste-nullifier-here';

fetch('http://localhost:9000/api/poh/issue', {
  method: 'POST',
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify({
    proof_hash: proofHash,
    nullifier: nullifier,
    wallet_address: '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1',
    public_signals: [30, 0]
  })
})
.then(r => r.json())
.then(d => console.log('Badge:', d))
```

**Expected Response:**
```json
{
  "success": true,
  "tx_hash": "0x...",
  "badge_id": "uuid",
  "token_id": 1,
  "message": "ZK-ID Badge issued successfully"
}
```

---

### 5️⃣ Test Duplicate Prevention

Run the badge issuance request again with same nullifier:

```javascript
// Should fail with 400 error
fetch('http://localhost:9000/api/poh/issue', {
  method: 'POST',
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify({
    proof_hash: proofHash,
    nullifier: nullifier,
    wallet_address: '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1',
    public_signals: [30, 0]
  })
})
.then(r => r.json())
.then(d => console.log('Duplicate:', d))
```

**Expected:**
```json
{
  "detail": "Badge already issued for this identity"
}
```

---

### 6️⃣ Verify in MongoDB

```bash
# Connect to MongoDB
mongosh

# Switch to database
use aura_protocol

# Check enrollments
db.enrollments.find().pretty()

# Check proofs
db.proofs.find().pretty()

# Check badges
db.badges.find().pretty()
```

**Expected:**
- ✅ 1 enrollment document
- ✅ 1 proof document
- ✅ 1 badge document
- ✅ Nullifier matches across documents

---

### 7️⃣ Verify in Frontend

1. Go to http://localhost:3000/dashboard
2. Should see badge in "Your Badges" section

**Expected:**
- ✅ Badge card displays
- ✅ Shows "Proof of Humanity" badge
- ✅ Shows token ID
- ✅ Shows verification level

---

## 🔧 Common Issues & Fixes

### Issue: "Enrollment failed"
**Fix:** Check backend logs, ensure MongoDB is running

### Issue: "Score below threshold"
**Fix:** Score must be ≥60. Without OAuth, score is ~30 (on-chain only)

### Issue: "Proof verification failed"
**Fix:** Check proof_hash and nullifier are correct

### Issue: Badge not showing in dashboard
**Fix:** 
1. Check MongoDB has badge document
2. Refresh dashboard page
3. Check wallet address matches

---

## 🎯 Success Criteria

✅ All 4 steps complete without errors
✅ Badge stored in MongoDB
✅ Badge displays in dashboard
✅ Duplicate prevention works
✅ Nullifier system prevents double-minting

---

## 📊 Test Results Template

```
Date: ___________
Tester: ___________

[ ] Step 1: Enrollment - PASS/FAIL
[ ] Step 2: Proof Generation - PASS/FAIL
[ ] Step 3: Badge Issuance - PASS/FAIL
[ ] Step 4: Duplicate Prevention - PASS/FAIL
[ ] Step 5: MongoDB Verification - PASS/FAIL
[ ] Step 6: Frontend Display - PASS/FAIL

Notes:
_________________________________
_________________________________
```

---

## 🚀 Next: Test with Real OAuth

Once basic flow works, test with real GitHub/Twitter OAuth:

1. Click "Connect GitHub" → Authorize → Callback
2. Click "Connect Twitter" → Authorize → Callback
3. Score should be higher (60-100)
4. Complete full flow

**Expected Score Breakdown:**
- GitHub: 0-40 points
- Twitter: 0-30 points
- On-chain: 0-30 points
- **Total: 0-100 points**

---

**Good luck testing! 🎉**
