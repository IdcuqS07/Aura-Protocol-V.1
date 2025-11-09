# Deploy AI Risk Oracle - Manual Steps

## ✅ What's Been Added

### Backend (Already on VPS):
- `ai_risk_oracle.py` - AI risk prediction engine
- `oracle_routes.py` - API endpoints for risk assessment
- Already imported in `server.py` (lines 730-731)

### Frontend (Need to Deploy):
- AI Risk Oracle section in `CreditPassport.js`
- Shows: Risk Score, Trust Score, Confidence, Risk Factors

---

## 🚀 Deployment Steps

### Step 1: Build Frontend Locally
```bash
cd frontend
yarn build
```

### Step 2: Upload to VPS
```bash
# From project root
scp -r frontend/build/* root@103.127.132.132:/var/www/aurapass.xyz/
```

### Step 3: Set Permissions on VPS
```bash
ssh root@103.127.132.132
chown -R www-data:www-data /var/www/aurapass.xyz
chmod -R 755 /var/www/aurapass.xyz
nginx -t && systemctl reload nginx
exit
```

---

## 🧪 Testing

1. Visit: https://www.aurapass.xyz/passport
2. Connect wallet
3. If passport exists, scroll down to see **AI Risk Oracle** section
4. Click "Generate AI Risk Assessment" button
5. Should show:
   - Risk Score (0-100)
   - Trust Score (0-100)
   - Confidence (%)
   - Risk Factors (if any)

---

## 📊 API Endpoints (Already Live)

### Get Risk Score
```bash
curl -X POST https://www.aurapass.xyz/api/oracle/risk-score \
  -H "Content-Type: application/json" \
  -d '{"wallet_address": "YOUR_WALLET"}'
```

### Get Lending Recommendation
```bash
curl -X POST https://www.aurapass.xyz/api/oracle/lending-recommendation \
  -H "Content-Type: application/json" \
  -d '{"wallet_address": "YOUR_WALLET", "loan_amount": 1000}'
```

### Get Risk History
```bash
curl https://www.aurapass.xyz/api/oracle/risk-history/YOUR_WALLET
```

### Get Oracle Stats
```bash
curl https://www.aurapass.xyz/api/oracle/stats
```

---

## 🎯 Features

### AI Risk Oracle calculates:
1. **Risk Score (0-100)**: Lower = safer
   - Based on PoH score (35%)
   - Badge count (20%)
   - On-chain activity (25%)
   - Account age (10%)
   - Score velocity (10%)

2. **Trust Score (0-100)**: Inverse of risk score

3. **Confidence (0-100%)**: Prediction accuracy based on data completeness

4. **Risk Factors**: Identifies specific issues:
   - Low PoH score
   - Few badges
   - Low on-chain activity
   - New account
   - Declining score

### Risk Levels:
- **Low Risk**: 0-30 (Green)
- **Medium Risk**: 31-60 (Yellow)
- **High Risk**: 61-100 (Red)

---

## 🔧 Troubleshooting

### If AI Oracle doesn't show:
1. Check browser console for errors
2. Verify passport exists: `curl https://www.aurapass.xyz/api/passport/YOUR_WALLET`
3. Test API directly: `curl -X POST https://www.aurapass.xyz/api/oracle/risk-score -H "Content-Type: application/json" -d '{"wallet_address": "YOUR_WALLET"}'`

### If "Passport not found" error:
1. Create passport first: `./force-create-passport.sh`
2. Or mint a badge (passport auto-creates)

---

## 📈 Next Steps

After deployment:
1. Test with your wallet
2. Check risk prediction accuracy
3. Share API with DeFi protocols
4. Monitor usage via `/api/oracle/stats`

---

**Status**: ✅ Code Complete, Ready to Deploy
**Estimated Deploy Time**: 5 minutes
