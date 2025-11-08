# 🚀 DEPLOYMENT CHECKLIST

Quick checklist to complete Gelombang 2 deployment.

---

## ✅ STEP 1: Deploy PoH Backend (5 minutes)

### Commands:
```bash
# 1. SSH to VPS
ssh root@165.232.166.78

# 2. Navigate to backend
cd /var/www/aura-backend-new

# 3. Backup current server
cp server.py server.py.backup

# 4. Pull latest code
git pull origin main

# 5. Verify files exist
ls -la poh_routes.py github_service.py twitter_service.py onchain_service.py polygon_id_service.py

# 6. Restart backend on port 9000
pm2 delete aura-backend
pm2 start "uvicorn server:app --host 0.0.0.0 --port 9000" --name aura-backend
pm2 save

# 7. Verify port 9000
lsof -i :9000

# 8. Check logs
pm2 logs aura-backend --lines 50

# 9. Test API (should return JSON)
curl http://localhost:9000/api/

# 10. Test PoH endpoint (should return error about missing fields, not 404)
curl http://localhost:9000/api/poh/enroll
```

### Expected Result:
- ✅ PoH routes loaded
- ✅ No 404 errors
- ✅ Backend running on port 9000
- ✅ API returns JSON response
- ✅ Port 9000 is listening

---

## ✅ STEP 2: Setup OAuth Credentials (30 minutes)

### A. GitHub OAuth App
1. Go to: https://github.com/settings/developers
2. Click "New OAuth App"
3. Fill in:
   - **Application name**: Aura Protocol
   - **Homepage URL**: https://www.aurapass.xyz
   - **Authorization callback URL**: `https://api.aurapass.xyz/api/poh/callback`
4. Click "Register application"
5. Copy **Client ID** and **Client Secret**

### B. Twitter OAuth App
1. Go to: https://developer.twitter.com/en/portal/dashboard
2. Create new app or use existing
3. Go to "User authentication settings"
4. Enable OAuth 2.0
5. Add callback URL: `https://api.aurapass.xyz/api/poh/callback`
6. Copy **Client ID** and **Client Secret**

### C. Alchemy API Key
1. Go to: https://www.alchemy.com/
2. Sign up or login
3. Create new app:
   - **Chain**: Polygon
   - **Network**: Amoy (testnet)
4. Copy **API Key**

### D. Update VPS .env
```bash
# SSH to VPS
ssh root@165.232.166.78

# Edit .env file
cd /var/www/aura-backend-new
nano .env

# Add these lines:
GITHUB_CLIENT_ID=your_github_client_id_here
GITHUB_CLIENT_SECRET=your_github_client_secret_here
GITHUB_REDIRECT_URI=https://api.aurapass.xyz/api/poh/callback

TWITTER_CLIENT_ID=your_twitter_client_id_here
TWITTER_CLIENT_SECRET=your_twitter_client_secret_here
TWITTER_REDIRECT_URI=https://api.aurapass.xyz/api/poh/callback

ALCHEMY_API_KEY=your_alchemy_api_key_here

# Save: Ctrl+X, Y, Enter

# Restart backend
pm2 restart aura-backend
```

---

## ✅ STEP 3: Test PoH Flow (10 minutes)

### Test Steps:
1. **Visit**: https://www.aurapass.xyz/verify
2. **Connect Wallet**: Click "Connect Wallet"
3. **Connect GitHub**:
   - Click "Connect GitHub"
   - Should redirect to GitHub
   - Authorize app
   - Should return to site with success message
4. **Connect Twitter**:
   - Click "Connect Twitter"
   - Should redirect to Twitter
   - Authorize app
   - Should return to site with success message
5. **Complete Enrollment**:
   - Click "Complete Enrollment"
   - Should calculate score (0-100)
   - Should generate ZK proof
6. **Mint Badge**:
   - Click "Mint Badge"
   - Confirm transaction in wallet
   - Wait for confirmation
   - Badge should appear in "My Badges"

### Expected Results:
- ✅ GitHub OAuth works
- ✅ Twitter OAuth works
- ✅ Score calculated (e.g., 75/100)
- ✅ ZK proof generated
- ✅ Badge minted on-chain
- ✅ Transaction hash visible

---

## ✅ STEP 4: Verify Everything Works

### Check Backend:
```bash
# Check PM2 status
pm2 status

# Check logs
pm2 logs aura-backend --lines 100

# Test PoH endpoint
curl http://localhost:9000/api/poh/enroll

# Test main API
curl http://localhost:9000/api/
```

### Check Frontend:
1. Visit: https://www.aurapass.xyz/
2. Check analytics dashboard (should show updated stats)
3. Visit: https://www.aurapass.xyz/verify (PoH page)
4. Visit: https://www.aurapass.xyz/badges (badges page)
5. Visit: https://www.aurapass.xyz/passport (passport page)

### Check Smart Contracts:
1. Visit: https://amoy.polygonscan.com/address/0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678
2. Check recent transactions
3. Verify badge mints

---

## 📋 TROUBLESHOOTING

### Issue: 404 on /api/poh/enroll
**Solution**: Backend not updated. Run Step 1 again.

### Issue: OAuth redirect fails
**Solution**: Check callback URLs match exactly:
- GitHub: `https://api.aurapass.xyz/api/poh/callback`
- Twitter: `https://api.aurapass.xyz/api/poh/callback`

### Issue: On-chain data fetch fails
**Solution**: Check Alchemy API key is correct and app is on Polygon Amoy.

### Issue: Badge mint fails
**Solution**: 
- Check wallet has MATIC for gas
- Check contract address is correct
- Check backend wallet has MATIC

### Issue: PM2 not restarting
**Solution**:
```bash
pm2 delete all
pm2 start "uvicorn server:app --host 0.0.0.0 --port 9000" --name aura-backend
pm2 save
```

---

## 🎯 SUCCESS CRITERIA

After completing all steps, you should have:

- ✅ PoH backend deployed and running
- ✅ OAuth credentials configured
- ✅ GitHub OAuth working
- ✅ Twitter OAuth working
- ✅ On-chain data fetching working
- ✅ Score calculation working (0-100)
- ✅ ZK proof generation working
- ✅ Badge minting working
- ✅ All endpoints returning 200 (not 404)
- ✅ Site fully functional at https://www.aurapass.xyz

---

## 📞 NEED HELP?

If you encounter issues:

1. Check PM2 logs: `pm2 logs aura-backend`
2. Check backend logs: `tail -f /var/www/aura-backend-new/backend.log`
3. Check nginx logs: `tail -f /var/log/nginx/error.log`
4. Test endpoints with curl
5. Check browser console for errors

---

## 🎉 COMPLETION

Once all steps are complete:

**Gelombang 2 is LIVE!** 🚀

You now have:
- ✅ Real identity verification (PoH)
- ✅ On-chain credit passports
- ✅ Public Proof-as-a-Service API
- ✅ Universal trust infrastructure

**Next**: Onboard users, issue API keys, integrate with dApps!

---

> "Universal Trust in a Trustless World" - Aura Protocol
