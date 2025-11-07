# 🔐 Proof of Humanity (PoH) Setup Guide

## Overview

Panduan lengkap untuk setup OAuth credentials dan testing PoH system.

**Status**: Backend & Frontend sudah 90% complete, tinggal setup credentials (10%)

---

## 📋 Prerequisites

- GitHub Account
- Twitter Developer Account
- Alchemy Account
- Access ke VPS/Server

---

## 1️⃣ GitHub OAuth Setup

### Step 1: Create OAuth App

1. Login ke GitHub
2. Go to: **Settings** → **Developer settings** → **OAuth Apps**
3. Click **"New OAuth App"**

### Step 2: Fill Application Details

```
Application name: Aura Protocol PoH
Homepage URL: https://www.aurapass.xyz
Authorization callback URL: https://www.aurapass.xyz/poh/callback
```

**For Local Development:**
```
Homepage URL: http://localhost:3000
Authorization callback URL: http://localhost:3000/poh/callback
```

### Step 3: Get Credentials

After creating, you'll get:
- **Client ID**: `Ov23li...` (copy this)
- **Client Secret**: Click "Generate a new client secret" (copy this)

### Step 4: Update .env

**Backend (.env)**:
```bash
GITHUB_CLIENT_ID=your_client_id_here
GITHUB_CLIENT_SECRET=your_client_secret_here
GITHUB_REDIRECT_URI=http://localhost:3000/poh/callback
```

**Frontend (.env)**:
```bash
REACT_APP_GITHUB_CLIENT_ID=your_client_id_here
```

---

## 2️⃣ Twitter OAuth Setup

### Step 1: Create Developer Account

1. Go to: https://developer.twitter.com/
2. Apply for Developer Account (if not already)
3. Create a new Project & App

### Step 2: Create App

1. Go to **Developer Portal** → **Projects & Apps**
2. Click **"Create App"**
3. Name: `Aura Protocol PoH`

### Step 3: Setup OAuth 2.0

1. Go to your app settings
2. Click **"Set up"** under OAuth 2.0
3. Set **Type of App**: Web App
4. Add **Callback URL**: `https://www.aurapass.xyz/poh/callback`
5. Add **Website URL**: `https://www.aurapass.xyz`

**For Local Development:**
```
Callback URL: http://localhost:3000/poh/callback
Website URL: http://localhost:3000
```

### Step 4: Get Credentials

Go to **Keys and tokens** tab:
- **API Key** (Client ID)
- **API Secret Key** (Client Secret)
- **Bearer Token** (optional)

### Step 5: Update .env

**Backend (.env)**:
```bash
TWITTER_CLIENT_ID=your_api_key_here
TWITTER_CLIENT_SECRET=your_api_secret_here
TWITTER_REDIRECT_URI=http://localhost:3000/poh/callback
```

**Frontend (.env)**:
```bash
REACT_APP_TWITTER_CLIENT_ID=your_api_key_here
```

---

## 3️⃣ Alchemy API Setup

### Step 1: Create Account

1. Go to: https://www.alchemy.com/
2. Sign up / Login
3. Create a new App

### Step 2: Create App

1. Click **"Create App"**
2. Fill details:
   - **Name**: Aura Protocol
   - **Chain**: Polygon
   - **Network**: Polygon Amoy (Testnet)

### Step 3: Get API Key

1. Go to your app dashboard
2. Click **"View Key"**
3. Copy **API Key** and **HTTPS URL**

### Step 4: Update .env

**Backend (.env)**:
```bash
ALCHEMY_API_KEY=your_api_key_here
ALCHEMY_POLYGON_URL=https://polygon-amoy.g.alchemy.com/v2/your_api_key
```

---

## 4️⃣ Complete .env Files

### Backend (.env)

```bash
# MongoDB
MONGO_URL=mongodb://localhost:27017
DB_NAME=aura_protocol

# CORS
CORS_ORIGINS=http://localhost:3000,https://www.aurapass.xyz

# GitHub OAuth
GITHUB_CLIENT_ID=your_github_client_id
GITHUB_CLIENT_SECRET=your_github_client_secret
GITHUB_REDIRECT_URI=http://localhost:3000/poh/callback

# Twitter OAuth
TWITTER_CLIENT_ID=your_twitter_api_key
TWITTER_CLIENT_SECRET=your_twitter_api_secret
TWITTER_REDIRECT_URI=http://localhost:3000/poh/callback

# Alchemy
ALCHEMY_API_KEY=your_alchemy_api_key
ALCHEMY_POLYGON_URL=https://polygon-amoy.g.alchemy.com/v2/your_api_key

# Polygon
POLYGON_PRIVATE_KEY=your_deployer_private_key
POLYGON_RPC_URL=https://rpc-amoy.polygon.technology
```

### Frontend (.env)

```bash
# Backend URL
REACT_APP_BACKEND_URL=http://localhost:9000

# OAuth Client IDs (public, safe to expose)
REACT_APP_GITHUB_CLIENT_ID=your_github_client_id
REACT_APP_TWITTER_CLIENT_ID=your_twitter_api_key
```

---

## 5️⃣ Testing PoH Flow

### Local Testing

1. **Start MongoDB**:
```bash
brew services start mongodb/brew/mongodb-community
```

2. **Start Backend**:
```bash
cd backend
source venv/bin/activate
uvicorn server:app --reload --host 0.0.0.0 --port 9000
```

3. **Start Frontend**:
```bash
cd frontend
yarn start
```

4. **Open Browser**: http://localhost:3000/poh

### Test Checklist

#### ✅ Step 1: GitHub Verification
- [ ] Click "Connect GitHub"
- [ ] Redirects to GitHub OAuth
- [ ] Authorize app
- [ ] Redirects back with code
- [ ] Backend exchanges code for token
- [ ] Fetches user data (username, repos, followers)
- [ ] Calculates GitHub score (0-35 points)
- [ ] Shows success message

#### ✅ Step 2: Twitter Verification
- [ ] Click "Connect Twitter"
- [ ] Redirects to Twitter OAuth
- [ ] Authorize app
- [ ] Redirects back with code
- [ ] Backend exchanges code for token
- [ ] Fetches user data (username, followers, tweets)
- [ ] Calculates Twitter score (0-35 points)
- [ ] Shows success message

#### ✅ Step 3: On-Chain Verification
- [ ] Connect wallet (MetaMask)
- [ ] Click "Verify On-Chain"
- [ ] Backend queries Alchemy API
- [ ] Fetches transaction count
- [ ] Fetches token balances
- [ ] Calculates on-chain score (0-30 points)
- [ ] Shows success message

#### ✅ Step 4: Generate Proof & Mint
- [ ] Shows total score (0-100)
- [ ] Shows uniqueness level (Low/Medium/High)
- [ ] Click "Generate ZK Proof"
- [ ] Backend generates proof hash
- [ ] Click "Mint Badge"
- [ ] Signs transaction
- [ ] Badge minted on-chain
- [ ] Shows transaction hash
- [ ] Badge appears in /zk-badges

---

## 6️⃣ Troubleshooting

### GitHub OAuth Errors

**Error**: `redirect_uri_mismatch`
- **Fix**: Pastikan callback URL di GitHub OAuth App sama dengan `GITHUB_REDIRECT_URI`

**Error**: `bad_verification_code`
- **Fix**: Code sudah expired, coba lagi (code hanya valid 10 menit)

### Twitter OAuth Errors

**Error**: `invalid_request`
- **Fix**: Pastikan Twitter app sudah enable OAuth 2.0

**Error**: `unauthorized_client`
- **Fix**: Callback URL tidak match, update di Twitter Developer Portal

### Alchemy Errors

**Error**: `Invalid API key`
- **Fix**: Copy ulang API key dari Alchemy dashboard

**Error**: `Network not supported`
- **Fix**: Pastikan menggunakan Polygon Amoy, bukan Mainnet

### Backend Errors

**Error**: `GITHUB_CLIENT_ID not found`
- **Fix**: Pastikan .env file ada di folder `backend/`

**Error**: `MongoDB connection failed`
- **Fix**: Start MongoDB: `brew services start mongodb/brew/mongodb-community`

---

## 7️⃣ Production Deployment

### Update Production .env

**VPS Backend (.env)**:
```bash
# Use production URLs
GITHUB_REDIRECT_URI=https://www.aurapass.xyz/poh/callback
TWITTER_REDIRECT_URI=https://www.aurapass.xyz/poh/callback
CORS_ORIGINS=https://www.aurapass.xyz
```

**VPS Frontend (.env)**:
```bash
REACT_APP_BACKEND_URL=https://api.aurapass.xyz
```

### Update OAuth Apps

1. **GitHub**: Add production callback URL
2. **Twitter**: Add production callback URL

### Deploy Steps

```bash
# SSH to VPS
ssh user@your-vps-ip

# Pull latest code
cd /path/to/Aura-Protocol-V.1-main
git pull origin main

# Update backend .env
nano backend/.env
# (paste production credentials)

# Restart backend
pm2 restart aura-backend

# Update frontend .env
nano frontend/.env
# (paste production backend URL)

# Rebuild frontend
cd frontend
yarn build

# Restart nginx
sudo systemctl restart nginx
```

---

## 8️⃣ Monitoring & Logs

### Check Backend Logs

```bash
# PM2 logs
pm2 logs aura-backend

# Or direct logs
tail -f backend/logs/app.log
```

### Check PoH Enrollments

```bash
# MongoDB query
mongosh aura_protocol
db.poh_enrollments.find().pretty()
```

### Check API Calls

```bash
# GitHub API calls
curl http://localhost:9000/api/poh/github/callback?code=test_code

# Twitter API calls
curl http://localhost:9000/api/poh/twitter/callback?code=test_code
```

---

## 9️⃣ Security Checklist

- [ ] Never commit .env files to GitHub
- [ ] Use different credentials for dev/prod
- [ ] Rotate secrets regularly
- [ ] Enable rate limiting on OAuth endpoints
- [ ] Monitor for suspicious activity
- [ ] Use HTTPS in production
- [ ] Validate all OAuth callbacks
- [ ] Sanitize user inputs

---

## 🎯 Success Criteria

### Phase 1 Complete When:
- [ ] All OAuth credentials configured
- [ ] Local testing passes all steps
- [ ] Production deployment successful
- [ ] 10+ users complete PoH flow
- [ ] Average score > 60 points
- [ ] No OAuth errors in logs

---

## 📞 Support

**Issues?**
- Check logs: `pm2 logs aura-backend`
- Test endpoints: Use Postman collection
- MongoDB: `mongosh aura_protocol`

**Need Help?**
- GitHub Issues: https://github.com/IdcuqS07/Aura-Protocol-V.1/issues
- Discord: (add link)

---

**Last Updated**: January 2025  
**Status**: Ready for OAuth Setup (10% remaining)
