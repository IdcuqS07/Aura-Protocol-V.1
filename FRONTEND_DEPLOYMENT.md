# 🚀 Frontend Deployment Guide

## ✅ Fixed Issues
- ✅ Removed all localhost references
- ✅ Updated `.env` with production backend URL
- ✅ Created centralized API config (`src/config/api.js`)
- ✅ All components now use production URLs

## 📝 Environment Variables

### `.env` (Production)
```bash
REACT_APP_BACKEND_URL=http://159.65.134.137:9000
REACT_APP_GITHUB_CLIENT_ID=Ov23liBkJpXGppFuyWWV
REACT_APP_TWITTER_CLIENT_ID=ZkNHUnEwSk5STWtKRWk2cW1fQWU6MTpjaQ
REACT_APP_CHAIN_ID=80002
REACT_APP_BADGE_CONTRACT=0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678
REACT_APP_PASSPORT_CONTRACT=0x1112373c9954B9bbFd91eb21175699b609A1b551
REACT_APP_PROOF_REGISTRY=0x296DB144E62C8C826bffA4503Dc9Fbf29F25D44B
```

## 🔧 Deployment Steps

### 1. Build Frontend
```bash
cd frontend
yarn install
yarn build
```

### 2. Deploy to VPS
```bash
# SSH to VPS
ssh root@159.65.134.137

# Navigate to project
cd /root/Aura-Protocol-V.1-main/frontend

# Pull latest changes
git pull origin main

# Install dependencies
yarn install

# Build production
yarn build

# Restart nginx (if using nginx)
sudo systemctl restart nginx
```

### 3. Verify Deployment
- Visit: https://www.aurapass.xyz
- Check browser console for errors
- Test wallet connection
- Test PoH flow
- Test Credit Passport

## 🔍 Files Changed

1. **`.env`** - Added production backend URL
2. **`src/config/api.js`** - New centralized config file
3. **`src/components/RiskOracle.js`** - Updated fallback URL

## 📦 Components Using Backend URL

All components now properly use `process.env.REACT_APP_BACKEND_URL`:
- ✅ APIDashboard.js
- ✅ CreditPassport.js
- ✅ ProofOfHumanity.js
- ✅ Waitlist.js
- ✅ VerifyIdentity.js
- ✅ Analytics.js
- ✅ Premium.js
- ✅ RiskOracle.js
- ✅ AdminWaitlist.js
- ✅ AdminMonitoring.js

## 🎯 Next Steps

1. **Build & Test Locally**
   ```bash
   yarn build
   serve -s build
   ```

2. **Deploy to VPS**
   - Copy build folder to VPS
   - Configure nginx/apache
   - Test production site

3. **Monitor**
   - Check browser console
   - Monitor API calls
   - Test all features

## 🚨 Important Notes

- **DO NOT** commit `.env` to git (already in `.gitignore`)
- **ALWAYS** use `process.env.REACT_APP_BACKEND_URL`
- **NEVER** hardcode localhost in components
- Use `src/config/api.js` for centralized config

## 🔗 URLs

- **Frontend**: https://www.aurapass.xyz
- **Backend**: http://159.65.134.137:9000
- **Polygon Amoy**: https://amoy.polygonscan.com

---

**Status**: ✅ Ready for deployment
**Last Updated**: January 2025
