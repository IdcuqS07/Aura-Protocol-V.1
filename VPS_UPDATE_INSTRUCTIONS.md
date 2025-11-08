# 🚀 VPS UPDATE INSTRUCTIONS - CREDIT PASSPORT

**Contract Deployed**: ✅ CreditPassport  
**Address**: `0x2E707Ce007dFAb6767da02d740451EACf18E1e58`  
**Time Required**: 5 minutes

---

## 📋 STEP-BY-STEP INSTRUCTIONS

### 1. SSH ke VPS
```bash
ssh root@your-vps-ip
```

### 2. Update Backend Code
```bash
cd /var/www/aura-backend-new
git pull origin main
```

### 3. Update .env File
```bash
nano .env
```

**Add this line**:
```bash
CREDIT_PASSPORT_ADDRESS=0x2E707Ce007dFAb6767da02d740451EACf18E1e58
```

**Save**: `Ctrl+O`, `Enter`, `Ctrl+X`

### 4. Restart Backend
```bash
/var/www/restart-backend.sh
```

### 5. Check Backend Status
```bash
pm2 status
pm2 logs aura-backend --lines 20
```

---

## ✅ VERIFICATION

### Test Passport Creation
```bash
curl -X POST https://www.aurapass.xyz/api/passport/create \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "0x96eb6DcBb03cE5818b9dF1446c1df378eb98De15",
    "wallet_address": "0x96eb6DcBb03cE5818b9dF1446c1df378eb98De15"
  }'
```

**Expected Response**:
```json
{
  "success": true,
  "passport_id": "PASS-...",
  "credit_score": 400,
  "grade": "Fair",
  "risk_level": "medium",
  "message": "Credit Passport created successfully"
}
```

### Check Frontend
1. Go to: https://www.aurapass.xyz/passport
2. Connect wallet
3. Click "Create Passport"
4. Should see passport card with score

---

## 🎉 DONE!

After these steps:
- ✅ CreditPassport contract deployed
- ✅ Backend updated with contract address
- ✅ Backend restarted
- ✅ Passport creation working

**Phase 2: Credit Passport** → ✅ **100% COMPLETE!**

---

## 📊 ALL DEPLOYED CONTRACTS

```
SimpleZKBadge:    0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678
ProofRegistry:    0x296DB144E62C8C826bffA4503Dc9Fbf29F25D44B
CreditPassport:   0x2E707Ce007dFAb6767da02d740451EACf18E1e58
```

---

**Next**: Test passport minting on production! 🚀
