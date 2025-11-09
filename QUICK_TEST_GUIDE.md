# ⚡ Quick Test Guide - Aura Protocol

## 🎯 5-Minute Quick Test

### 1. Open App
```
https://www.aurapass.xyz/
```

### 2. Connect Wallet
- Click "Connect Wallet"
- Approve MetaMask
- Switch to Polygon Amoy if needed

### 3. Test PoH Flow
```
https://www.aurapass.xyz/verify
```
- Click "Connect GitHub"
- **Accept "Untrusted Developer" warning** (click Continue)
- Authorize app
- Check if score appears

### 4. View Credit Passport
```
https://www.aurapass.xyz/passport
```
- See your credit score
- Check badge list
- Try "Mint Passport" if available

### 5. Test AI Risk Oracle
- Scroll to "AI Risk Oracle" section
- Click "Generate AI Risk Assessment"
- Check risk score and factors

---

## 🔑 Test Credentials

### Demo API Keys
```bash
# Free tier (100 req/day)
demo_key_12345

# Pro tier (1000 req/day)
premium_key_67890
```

### Test Wallet
```
0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb
```

### Smart Contracts (Polygon Amoy)
```
SimpleZKBadge:    0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678
CreditPassport:   0x1112373c9954B9bbFd91eb21175699b609A1b551
ProofRegistry:    0x296DB144E62C8C826bffA4503Dc9Fbf29F25D44B
```

---

## 🧪 Quick API Tests

### Test Analytics
```bash
curl https://www.aurapass.xyz/api/analytics
```

### Test Credit Score
```bash
curl "https://www.aurapass.xyz/api/passport/score/YOUR_WALLET"
```

### Test with API Key
```bash
curl -X POST "https://www.aurapass.xyz/api/proof/generate?user_id=test" \
  -H "X-API-Key: demo_key_12345" \
  -H "Content-Type: application/json" \
  -d '{"claim_type":"test","claim_data":{}}'
```

---

## ⚠️ Expected Warnings

### Twitter OAuth
```
"Untrusted Developer - This developer is not verified"
```
**Action**: Click "Continue" - Safe for testing

### GitHub OAuth
```
"Unverified App"
```
**Action**: Click "Authorize" - Safe for testing

### MetaMask
```
"Unknown Contract"
```
**Action**: Normal for testnet - Proceed

---

## ✅ Success Indicators

- [ ] Wallet connects
- [ ] GitHub OAuth completes
- [ ] Score calculated (0-100)
- [ ] Badge minted (transaction hash shown)
- [ ] Passport displays credit score
- [ ] AI Risk Oracle generates prediction

---

## 🐛 If Something Breaks

### Frontend Not Loading
```bash
# Check if frontend is up
curl https://www.aurapass.xyz/
```

### API Not Responding
```bash
# Check backend health
curl https://www.aurapass.xyz/api/analytics
```

### Transaction Fails
- Check you're on Polygon Amoy testnet
- Get test MATIC from faucet
- Try again with higher gas

### OAuth Fails
- Clear browser cookies
- Try incognito mode
- Check redirect URL matches

---

## 📞 Quick Commands

### Check Backend Status
```bash
ssh root@159.65.134.137 "systemctl status aura-backend"
```

### View Backend Logs
```bash
ssh root@159.65.134.137 "journalctl -u aura-backend -n 50"
```

### Restart Backend
```bash
ssh root@159.65.134.137 "systemctl restart aura-backend"
```

### Check Database
```bash
ssh root@159.65.134.137 "mongosh aura_protocol --eval 'db.users.countDocuments()'"
```

---

## 🎯 What to Test

**Priority 1 (Must Work)**:
- ✅ Wallet connection
- ✅ GitHub OAuth
- ✅ Credit score calculation
- ✅ Badge display

**Priority 2 (Should Work)**:
- ✅ Twitter OAuth
- ✅ Badge minting
- ✅ Passport minting
- ✅ AI Risk Oracle

**Priority 3 (Nice to Have)**:
- ⏳ API key generation UI
- ⏳ Usage statistics
- ⏳ Advanced analytics

---

## 📊 Test Results Template

```
Date: __________
Tester: __________
Browser: __________

✅ Wallet Connected: Yes / No
✅ GitHub OAuth: Yes / No
✅ Twitter OAuth: Yes / No
✅ Score Calculated: Yes / No
✅ Badge Minted: Yes / No
✅ Passport Viewed: Yes / No
✅ AI Oracle Worked: Yes / No

Issues Found:
1. ___________________________
2. ___________________________
3. ___________________________

Overall: Pass / Fail / Partial
```

---

**Ready to test? Start here**: https://www.aurapass.xyz/
