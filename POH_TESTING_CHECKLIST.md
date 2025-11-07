# ✅ PoH Testing Checklist

Quick checklist untuk testing Proof of Humanity flow.

---

## 🔧 Pre-Testing Setup

- [ ] MongoDB running: `brew services start mongodb/brew/mongodb-community`
- [ ] Backend running: `uvicorn server:app --reload --port 9000`
- [ ] Frontend running: `yarn start`
- [ ] .env files configured with OAuth credentials
- [ ] Wallet connected (MetaMask with Polygon Amoy)
- [ ] Test wallet has MATIC for gas

---

## 1️⃣ GitHub Verification (35 points max)

### Test Flow:
- [ ] Navigate to `/poh`
- [ ] Click "Connect GitHub" button
- [ ] Redirects to `https://github.com/login/oauth/authorize`
- [ ] Shows app name "Aura Protocol PoH"
- [ ] Click "Authorize"
- [ ] Redirects back to `/poh/callback?code=...`
- [ ] Frontend sends code to backend
- [ ] Backend calls `/api/poh/github/callback`
- [ ] Backend exchanges code for access token
- [ ] Backend fetches GitHub user data
- [ ] Backend calculates score based on:
  - Account age (0-10 points)
  - Public repos (0-10 points)
  - Followers (0-10 points)
  - Contributions (0-5 points)
- [ ] Score displayed in UI
- [ ] Green checkmark appears
- [ ] "GitHub Connected" status shown

### Expected Score Breakdown:
```
Account Age: 2+ years = 10 points
Public Repos: 10+ repos = 10 points
Followers: 50+ followers = 10 points
Contributions: Active = 5 points
Total: 0-35 points
```

### Test Cases:
- [ ] **New Account**: Score < 10 points
- [ ] **Active Developer**: Score 20-30 points
- [ ] **Popular Account**: Score 30-35 points

---

## 2️⃣ Twitter Verification (35 points max)

### Test Flow:
- [ ] Click "Connect Twitter" button
- [ ] Redirects to `https://twitter.com/i/oauth2/authorize`
- [ ] Shows app name "Aura Protocol PoH"
- [ ] Click "Authorize app"
- [ ] Redirects back to `/poh/callback?code=...`
- [ ] Frontend sends code to backend
- [ ] Backend calls `/api/poh/twitter/callback`
- [ ] Backend exchanges code for access token
- [ ] Backend fetches Twitter user data
- [ ] Backend calculates score based on:
  - Account age (0-10 points)
  - Followers (0-15 points)
  - Tweet count (0-10 points)
- [ ] Score displayed in UI
- [ ] Green checkmark appears
- [ ] "Twitter Connected" status shown

### Expected Score Breakdown:
```
Account Age: 2+ years = 10 points
Followers: 1000+ = 15 points
Tweets: 500+ = 10 points
Total: 0-35 points
```

### Test Cases:
- [ ] **New Account**: Score < 10 points
- [ ] **Active User**: Score 15-25 points
- [ ] **Influencer**: Score 30-35 points

---

## 3️⃣ On-Chain Verification (30 points max)

### Test Flow:
- [ ] Wallet already connected
- [ ] Click "Verify On-Chain" button
- [ ] Backend calls Alchemy API
- [ ] Backend fetches:
  - Transaction count
  - Token balances (ERC-20, ERC-721)
  - Contract interactions
- [ ] Backend calculates score based on:
  - Transaction count (0-15 points)
  - Token holdings (0-10 points)
  - Contract interactions (0-5 points)
- [ ] Score displayed in UI
- [ ] Green checkmark appears
- [ ] "On-Chain Verified" status shown

### Expected Score Breakdown:
```
Transactions: 50+ txs = 15 points
Token Holdings: 5+ tokens = 10 points
Contract Interactions: Active = 5 points
Total: 0-30 points
```

### Test Cases:
- [ ] **New Wallet**: Score < 5 points
- [ ] **Active User**: Score 15-20 points
- [ ] **DeFi Power User**: Score 25-30 points

---

## 4️⃣ Score Calculation & Display

### Total Score (0-100):
- [ ] GitHub score displayed correctly
- [ ] Twitter score displayed correctly
- [ ] On-chain score displayed correctly
- [ ] Total score = GitHub + Twitter + On-chain
- [ ] Progress bar shows correct percentage
- [ ] Uniqueness level calculated:
  - 0-30: Low
  - 31-60: Medium
  - 61-100: High

### UI Elements:
- [ ] Score breakdown visible
- [ ] Each verification shows checkmark when complete
- [ ] Total score prominently displayed
- [ ] Uniqueness badge shown with color:
  - Red: Low (0-30)
  - Yellow: Medium (31-60)
  - Green: High (61-100)

---

## 5️⃣ ZK Proof Generation

### Test Flow:
- [ ] All 3 verifications complete
- [ ] "Generate ZK Proof" button enabled
- [ ] Click button
- [ ] Backend generates proof hash
- [ ] Proof hash displayed (0x...)
- [ ] "Proof Generated" status shown
- [ ] "Mint Badge" button enabled

### Proof Format:
```
Format: 0x[64 hex characters]
Example: 0x1a2b3c4d5e6f7890abcdef1234567890abcdef1234567890abcdef1234567890
```

---

## 6️⃣ Badge Minting

### Test Flow:
- [ ] Click "Mint Badge" button
- [ ] MetaMask popup appears
- [ ] Transaction details shown:
  - To: Badge Contract (0x9e63...)
  - Function: mintBadge
  - Gas estimate displayed
- [ ] Click "Confirm"
- [ ] Transaction submitted
- [ ] Loading state shown
- [ ] Transaction confirmed
- [ ] Success message with tx hash
- [ ] Badge appears in `/zk-badges`

### Verify On-Chain:
- [ ] Check Polygonscan: https://amoy.polygonscan.com/tx/[tx_hash]
- [ ] Transaction status: Success
- [ ] Badge minted event emitted
- [ ] Token ID assigned

---

## 7️⃣ Error Handling

### Test Error Cases:

#### OAuth Errors:
- [ ] User denies GitHub authorization → Shows error message
- [ ] User denies Twitter authorization → Shows error message
- [ ] Invalid OAuth code → Shows "Authentication failed"
- [ ] Expired OAuth code → Shows "Code expired, try again"

#### Network Errors:
- [ ] Backend offline → Shows "Connection error"
- [ ] Alchemy API down → Shows "On-chain verification failed"
- [ ] MongoDB down → Shows "Database error"

#### Wallet Errors:
- [ ] Wallet not connected → Shows "Connect wallet first"
- [ ] Wrong network → Shows "Switch to Polygon Amoy"
- [ ] Insufficient gas → Shows "Insufficient MATIC for gas"
- [ ] User rejects transaction → Shows "Transaction rejected"

---

## 8️⃣ Database Verification

### Check MongoDB:
```bash
mongosh aura_protocol

# Check PoH enrollments
db.poh_enrollments.find().pretty()

# Expected fields:
{
  id: "uuid",
  wallet_address: "0x...",
  github_score: 25,
  twitter_score: 20,
  onchain_score: 15,
  total_score: 60,
  uniqueness_level: "medium",
  zk_proof_hash: "0x...",
  github_data: {...},
  twitter_data: {...},
  onchain_data: {...},
  created_at: ISODate(...),
  completed_at: ISODate(...)
}
```

---

## 9️⃣ API Endpoint Testing

### Manual API Tests:

```bash
# Test GitHub callback
curl -X POST http://localhost:9000/api/poh/github/callback \
  -H "Content-Type: application/json" \
  -d '{"code": "test_code", "wallet_address": "0x..."}'

# Test Twitter callback
curl -X POST http://localhost:9000/api/poh/twitter/callback \
  -H "Content-Type: application/json" \
  -d '{"code": "test_code", "wallet_address": "0x..."}'

# Test on-chain verification
curl -X POST http://localhost:9000/api/poh/verify-onchain \
  -H "Content-Type: application/json" \
  -d '{"wallet_address": "0x..."}'

# Test proof generation
curl -X POST http://localhost:9000/api/poh/generate-proof \
  -H "Content-Type: application/json" \
  -d '{"enrollment_id": "uuid"}'

# Get enrollment status
curl http://localhost:9000/api/poh/enrollment/0x...
```

---

## 🎯 Success Criteria

### Phase 1 Complete When:
- [ ] All 9 test sections pass
- [ ] No console errors
- [ ] No backend errors in logs
- [ ] 5+ test users complete full flow
- [ ] Average score > 50 points
- [ ] All badges minted successfully
- [ ] Database records correct
- [ ] Production deployment successful

---

## 📊 Test Results Template

```
Date: ___________
Tester: ___________

GitHub Verification: ✅ / ❌
Twitter Verification: ✅ / ❌
On-Chain Verification: ✅ / ❌
Score Calculation: ✅ / ❌
Proof Generation: ✅ / ❌
Badge Minting: ✅ / ❌
Error Handling: ✅ / ❌
Database Records: ✅ / ❌
API Endpoints: ✅ / ❌

Total Score Achieved: ___/100
Uniqueness Level: Low / Medium / High
Badge Token ID: ___________
Transaction Hash: 0x___________

Notes:
_________________________________
_________________________________
```

---

**Ready to Test!** 🚀
