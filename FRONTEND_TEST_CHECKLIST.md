# 🧪 Frontend Testing Checklist

## Test URL: https://www.aurapass.xyz/

---

## ✅ Phase 1: Basic Navigation

- [ ] Homepage loads successfully
- [ ] Navigation menu works (Home, Verify, Passport, Roadmap, etc.)
- [ ] Footer links work
- [ ] Responsive design (mobile/desktop)

---

## ✅ Phase 2: Wallet Connection

- [ ] "Connect Wallet" button visible
- [ ] MetaMask popup appears
- [ ] Wallet connects successfully
- [ ] Wallet address displayed
- [ ] Network switch to Polygon Amoy works

---

## ✅ Phase 3: Proof of Humanity (PoH)

**URL**: https://www.aurapass.xyz/verify

### Step 1: GitHub OAuth
- [ ] "Connect GitHub" button works
- [ ] Redirects to GitHub OAuth
- [ ] Accept "Untrusted Developer" warning (click Continue)
- [ ] Redirects back with code
- [ ] GitHub data fetched (username, repos, followers)
- [ ] Score calculated (0-40 points)

### Step 2: Twitter OAuth
- [ ] "Connect Twitter" button works
- [ ] Redirects to Twitter OAuth
- [ ] Accept "Untrusted Developer" warning (click Continue)
- [ ] Redirects back with code
- [ ] Twitter data fetched (username, followers, tweets)
- [ ] Score calculated (0-30 points)

### Step 3: On-Chain Verification
- [ ] Wallet address auto-detected
- [ ] On-chain data fetched (tx count, balance)
- [ ] Score calculated (0-30 points)

### Step 4: Generate Proof & Mint Badge
- [ ] Total uniqueness score displayed (0-100)
- [ ] "Generate Proof" button works
- [ ] ZK proof generated
- [ ] "Mint Badge" button appears
- [ ] Transaction popup (MetaMask)
- [ ] Badge minted successfully
- [ ] Transaction hash displayed
- [ ] Badge appears in user profile

---

## ✅ Phase 4: Credit Passport

**URL**: https://www.aurapass.xyz/passport

### View Passport
- [ ] Passport page loads
- [ ] Credit score displayed (0-1000)
- [ ] Grade displayed (Excellent/Very Good/Good/Fair/Poor)
- [ ] Risk level displayed (Low/Medium/High)
- [ ] Score breakdown shown:
  - [ ] PoH Score (40%)
  - [ ] Badge Count (30%)
  - [ ] On-Chain Activity (30%)
  - [ ] Reputation (bonus)

### Mint/Update Passport
- [ ] "Mint Passport" button visible (if no passport)
- [ ] "Update Score" button visible (if passport exists)
- [ ] Transaction popup (MetaMask)
- [ ] Passport NFT minted/updated
- [ ] New score reflected on-chain

### Badge List
- [ ] All user badges displayed
- [ ] Badge types shown (PoH, Civic, Worldcoin, etc.)
- [ ] Badge metadata visible
- [ ] Token IDs displayed

---

## ✅ Phase 5: AI Risk Oracle

**URL**: https://www.aurapass.xyz/passport (Risk Oracle section)

### Generate Risk Assessment
- [ ] "Generate AI Risk Assessment" button visible
- [ ] Button triggers API call
- [ ] Loading state shown
- [ ] Risk score displayed (0-100)
- [ ] Trust score displayed (0-100)
- [ ] Confidence percentage shown
- [ ] Risk level with color (Low=Green, Medium=Yellow, High=Red)

### Risk Factors Breakdown
- [ ] Credit Score factor (weight: 30%)
- [ ] Badge Count factor (weight: 25%)
- [ ] PoH Score factor (weight: 20%)
- [ ] On-Chain Activity factor (weight: 15%)
- [ ] Account Age factor (weight: 10%)
- [ ] Each factor shows score and contribution

### Lending Recommendation
- [ ] Recommended loan amount displayed
- [ ] Interest rate suggested
- [ ] Collateral ratio shown
- [ ] Risk-adjusted terms visible

---

## ✅ Phase 6: Analytics Dashboard

**URL**: https://www.aurapass.xyz/analytics (or homepage stats)

- [ ] Total users count
- [ ] Verified users count
- [ ] Total passports minted
- [ ] Average credit score
- [ ] Transaction volume
- [ ] Risk distribution chart

---

## ✅ Phase 7: API Integration (Developer)

**URL**: https://www.aurapass.xyz/docs or README

- [ ] API documentation accessible
- [ ] Demo API keys work:
  - `demo_key_12345` (100 req/day)
  - `premium_key_67890` (1000 req/day)
- [ ] `/proof/generate` endpoint works
- [ ] `/proof/verify` endpoint works
- [ ] Rate limiting enforced
- [ ] Error messages clear

---

## ✅ Phase 8: Error Handling

- [ ] Network errors handled gracefully
- [ ] Transaction rejections handled
- [ ] Invalid inputs validated
- [ ] Loading states shown
- [ ] Success messages displayed
- [ ] Error messages user-friendly

---

## 🐛 Known Issues

### Expected Warnings:
1. **Twitter OAuth**: "Untrusted Developer" warning
   - **Solution**: Click "Continue" - safe for testing
   - **Production Fix**: Request Elevated Access

2. **GitHub OAuth**: May show "Unverified App"
   - **Solution**: Click "Authorize" - safe for testing

3. **MetaMask**: "Unknown Contract"
   - **Solution**: Normal for testnet contracts

### Not Implemented Yet:
- [ ] API Key generation UI (backend ready)
- [ ] Usage statistics dashboard
- [ ] Request logs viewer
- [ ] Advanced ML model training

---

## 📊 Success Criteria

**Minimum for Production**:
- ✅ 80%+ of features working
- ✅ No critical bugs
- ✅ Wallet connection stable
- ✅ At least 1 badge minted successfully
- ✅ Credit score calculation accurate
- ✅ AI Risk Oracle generating predictions

**Ideal for Launch**:
- ✅ 95%+ of features working
- ✅ All OAuth flows smooth
- ✅ 10+ test users with passports
- ✅ All smart contracts verified on PolygonScan
- ✅ Documentation complete

---

## 🚀 Testing Instructions

### Quick Test (5 minutes):
1. Open https://www.aurapass.xyz/
2. Connect wallet (MetaMask)
3. Go to /verify
4. Connect GitHub (click Continue on warning)
5. Check if score calculated
6. Try minting badge

### Full Test (30 minutes):
1. Complete all Phase 1-8 checklists
2. Test on mobile device
3. Test with different wallets
4. Test error scenarios
5. Document any bugs found

---

## 📝 Test Results

**Date**: _____________  
**Tester**: _____________  
**Browser**: _____________  
**Wallet**: _____________  

**Overall Status**: ⬜ Pass | ⬜ Fail | ⬜ Partial

**Notes**:
```
[Add any observations, bugs, or suggestions here]
```

---

**Next Steps After Testing**:
1. Fix critical bugs
2. Deploy fixes to VPS
3. Re-test
4. Update documentation
5. Prepare for user onboarding
