# ✅ DEPLOYMENT CHECKLIST

**Feature**: User Mint Credit Passport  
**Date**: January 2025  
**Status**: Ready to Deploy

---

## 📦 PRE-DEPLOYMENT

### Code Ready
- [x] Smart contract deployed: `0x1112373c9954B9bbFd91eb21175699b609A1b551`
- [x] Backend API updated
- [x] Frontend component updated
- [x] All code pushed to GitHub
- [x] Documentation complete

### Files Changed
- [x] `contracts/contracts/CreditPassport.sol`
- [x] `backend/passport_routes.py`
- [x] `frontend/src/utils/passportContract.js`
- [x] `frontend/src/components/CreditPassport.js`

---

## 🚀 DEPLOYMENT STEPS

### Step 1: Backend
```bash
cd /var/www/aura-backend-new
git pull origin main
/var/www/restart-backend.sh
```
- [ ] Git pull successful
- [ ] Backend restarted
- [ ] No errors in logs
- [ ] Port 9000 listening

### Step 2: Frontend
```bash
cd /var/www/aura-frontend
git pull origin main
yarn install
yarn build
sudo systemctl restart nginx
```
- [ ] Git pull successful
- [ ] Dependencies installed
- [ ] Build successful
- [ ] Nginx restarted

---

## ✅ VERIFICATION

### Backend Health
```bash
curl http://localhost:9000/api/passport/score/0x96eb6DcBb03cE5818b9dF1446c1df378eb98De15
```
- [ ] Returns 200 OK
- [ ] JSON response valid
- [ ] No errors

### Frontend Health
```bash
curl -I https://www.aurapass.xyz
```
- [ ] Returns 200 OK
- [ ] No 404 errors
- [ ] Site loads

### Contract Address
```bash
grep -r "0x1112373c9954B9bbFd91eb21175699b609A1b551" /var/www/aura-frontend/build/
```
- [ ] Contract address found in build
- [ ] Correct address

---

## 🧪 FUNCTIONAL TESTING

### Test 1: Visit Page
- [ ] Go to https://www.aurapass.xyz/passport
- [ ] Page loads without errors
- [ ] No console errors

### Test 2: Connect Wallet
- [ ] Click "Connect Wallet"
- [ ] MetaMask popup appears
- [ ] Wallet connects successfully
- [ ] Address displayed

### Test 3: Check Button
- [ ] "Mint Passport (Pay Gas)" button visible
- [ ] Button not disabled
- [ ] Button clickable

### Test 4: Fetch Score
- [ ] Click "Mint Passport"
- [ ] Confirmation dialog appears
- [ ] Shows PoH score
- [ ] Shows badge count
- [ ] Shows estimated credit score
- [ ] Shows gas estimate

### Test 5: Mint Transaction
- [ ] Click "Confirm" in dialog
- [ ] MetaMask popup appears
- [ ] Transaction details correct
- [ ] Gas estimate reasonable (~0.007 MATIC)
- [ ] Click "Confirm" in MetaMask
- [ ] Loading state shows "Minting..."

### Test 6: Confirmation
- [ ] Transaction succeeds
- [ ] Success message shows TX hash
- [ ] Passport card appears
- [ ] Credit score displayed
- [ ] Badge count correct
- [ ] Risk level shown

### Test 7: Verify On-Chain
- [ ] Visit PolygonScan
- [ ] Search TX hash
- [ ] Transaction confirmed
- [ ] Contract interaction visible
- [ ] Event emitted

---

## 🔍 ERROR TESTING

### Test Error Cases
- [ ] Try minting without PoH → Shows error
- [ ] Try minting twice → Shows "already exists"
- [ ] Reject MetaMask → Shows "rejected"
- [ ] Insufficient gas → Shows error

---

## 📊 MONITORING

### Logs to Watch
```bash
# Backend
pm2 logs aura-backend --lines 100

# Nginx
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log
```

### Metrics to Track
- [ ] API calls to `/passport/score`
- [ ] Successful mints
- [ ] Failed mints
- [ ] Average gas used
- [ ] Response times

---

## 🎯 SUCCESS CRITERIA

### Must Have
- [x] Contract deployed
- [ ] Backend deployed
- [ ] Frontend deployed
- [ ] Mint button works
- [ ] Transaction succeeds
- [ ] Passport displays

### Nice to Have
- [ ] No console errors
- [ ] Fast response times
- [ ] Good UX
- [ ] Clear error messages

---

## 📝 POST-DEPLOYMENT

### Documentation
- [x] Update README
- [x] Create deployment guide
- [x] Document contract address
- [x] Write testing guide

### Communication
- [ ] Announce feature
- [ ] Update users
- [ ] Share contract address
- [ ] Provide support

### Monitoring
- [ ] Watch logs for 1 hour
- [ ] Check for errors
- [ ] Monitor gas usage
- [ ] Track user adoption

---

## 🚨 ROLLBACK PLAN

If something goes wrong:

```bash
# Backend
cd /var/www/aura-backend-new
git reset --hard HEAD~3
/var/www/restart-backend.sh

# Frontend
cd /var/www/aura-frontend
git reset --hard HEAD~3
yarn build
sudo systemctl restart nginx
```

---

## 📞 SUPPORT

### If Issues Occur
1. Check logs: `pm2 logs aura-backend`
2. Check nginx: `tail -f /var/log/nginx/error.log`
3. Check contract: Visit PolygonScan
4. Rollback if needed

### Contact
- GitHub Issues
- Discord
- Email support

---

## ✅ FINAL CHECKLIST

Before going live:
- [ ] All tests passed
- [ ] No errors in logs
- [ ] Contract verified
- [ ] Documentation updated
- [ ] Team notified
- [ ] Monitoring active

**Ready to deploy?** ✅

---

**Contract**: `0x1112373c9954B9bbFd91eb21175699b609A1b551`  
**Network**: Polygon Amoy  
**Feature**: User Mint Credit Passport (Decentralized)

**Let's go!** 🚀
