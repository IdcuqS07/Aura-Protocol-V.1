# 🚀 USER TESTING DEPLOYMENT GUIDE

**Target**: Deploy Aura Protocol untuk user testing  
**Timeline**: 1-2 hours  
**Status**: Ready to deploy

---

## 📋 PRE-DEPLOYMENT CHECKLIST

### 1. Environment Setup
- [ ] VPS access: `root@103.127.132.132`
- [ ] Domain: `www.aurapass.xyz`
- [ ] MongoDB running
- [ ] Nginx configured
- [ ] SSL certificate active

### 2. OAuth Credentials (REQUIRED)
- [ ] GitHub OAuth App
- [ ] Twitter OAuth App (optional for now)
- [ ] Alchemy API Key

### 3. Wallet Setup
- [ ] Deployer wallet with MATIC
- [ ] Private key secured

---

## 🎯 DEPLOYMENT STEPS

### Step 1: Prepare Backend for Production

```bash
# 1. Update backend .env
cd backend
cat > .env << 'EOF'
# MongoDB
MONGO_URL=mongodb://localhost:27017
DB_NAME=aura_protocol

# OAuth (REPLACE WITH YOUR CREDENTIALS)
GITHUB_CLIENT_ID=your_github_client_id
GITHUB_CLIENT_SECRET=your_github_client_secret
TWITTER_CLIENT_ID=your_twitter_client_id
TWITTER_CLIENT_SECRET=your_twitter_client_secret

# Blockchain
ALCHEMY_API_KEY=your_alchemy_key
PRIVATE_KEY=your_wallet_private_key

# CORS
CORS_ORIGINS=https://www.aurapass.xyz,http://localhost:3000

# Contracts
BADGE_CONTRACT_ADDRESS=0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678
PASSPORT_CONTRACT_ADDRESS=0x1112373c9954B9bbFd91eb21175699b609A1b551
PROOF_REGISTRY_ADDRESS=0x296DB144E62C8C826bffA4503Dc9Fbf29F25D44B
EOF
```

### Step 2: Build Frontend for Production

```bash
# 1. Update frontend .env.production
cd frontend
cat > .env.production << 'EOF'
REACT_APP_BACKEND_URL=https://www.aurapass.xyz
REACT_APP_BADGE_CONTRACT=0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678
REACT_APP_PASSPORT_CONTRACT=0x1112373c9954B9bbFd91eb21175699b609A1b551
REACT_APP_NETWORK=polygon-amoy
EOF

# 2. Build frontend
yarn build

# 3. Create tarball
tar -czf build.tar.gz build/
```

### Step 3: Deploy Backend to VPS

```bash
# 1. SSH to VPS
ssh root@103.127.132.132

# 2. Update backend code
cd /root/Aura-Protocol-V.1-main
git pull origin main

# 3. Update .env with production credentials
nano backend/.env

# 4. Restart backend service
systemctl restart aura-backend
systemctl status aura-backend

# 5. Check logs
tail -f /root/Aura-Protocol-V.1-main/backend/backend.log
```

### Step 4: Deploy Frontend to VPS

```bash
# From local machine
scp frontend/build.tar.gz root@103.127.132.132:/tmp/

# SSH to VPS
ssh root@103.127.132.132

# Extract frontend
cd /var/www/aurapass.xyz
rm -rf *
tar -xzf /tmp/build.tar.gz --strip-components=1
chown -R www-data:www-data /var/www/aurapass.xyz
chmod -R 755 /var/www/aurapass.xyz

# Reload nginx
nginx -t && systemctl reload nginx
```

### Step 5: Verify Deployment

```bash
# Test backend
curl https://www.aurapass.xyz/api/

# Test frontend
curl https://www.aurapass.xyz/

# Test specific endpoints
curl https://www.aurapass.xyz/api/analytics
curl https://www.aurapass.xyz/api/oracle/stats
```

---

## 🧪 USER TESTING SCENARIOS

### Scenario 1: Basic Badge Minting
1. Visit https://www.aurapass.xyz/
2. Connect MetaMask wallet
3. Go to "Get Started"
4. Mint a demo badge
5. Check badge in wallet

### Scenario 2: Proof of Humanity (Limited)
1. Go to "Verify Identity"
2. Try GitHub OAuth (if configured)
3. See uniqueness score
4. Generate ZK proof

### Scenario 3: Credit Passport
1. Go to "Credit Passport"
2. Connect wallet
3. Click "Mint Passport"
4. View credit score
5. See badge aggregation

### Scenario 4: AI Risk Oracle
1. Open Credit Passport page
2. Scroll to AI Risk Oracle section
3. Click "Generate AI Risk Assessment"
4. View risk score, trust score, confidence
5. See risk factors breakdown

### Scenario 5: Public API Testing
1. Generate API key (if dashboard ready)
2. Test proof generation
3. Test proof verification
4. Check rate limiting

---

## 📊 MONITORING & METRICS

### Backend Monitoring
```bash
# Check backend status
systemctl status aura-backend

# View logs
tail -f /root/Aura-Protocol-V.1-main/backend/backend.log

# Check MongoDB
mongo aura_protocol --eval "db.stats()"
```

### Frontend Monitoring
```bash
# Check nginx status
systemctl status nginx

# View access logs
tail -f /var/log/nginx/access.log

# View error logs
tail -f /var/log/nginx/error.log
```

### Database Queries
```bash
# Connect to MongoDB
mongo aura_protocol

# Check collections
show collections

# Count documents
db.badges.count()
db.passports.count()
db.enrollments.count()
db.risk_predictions.count()

# View recent badges
db.badges.find().sort({created_at: -1}).limit(5)
```

---

## 🐛 TROUBLESHOOTING

### Issue: Backend not starting
```bash
# Check Python environment
cd /root/Aura-Protocol-V.1-main/backend
source venv/bin/activate
python --version

# Check dependencies
pip list | grep fastapi

# Test manually
uvicorn server:app --host 0.0.0.0 --port 9000
```

### Issue: Frontend not loading
```bash
# Check nginx config
nginx -t

# Check file permissions
ls -la /var/www/aurapass.xyz/

# Check nginx error log
tail -f /var/log/nginx/error.log
```

### Issue: OAuth not working
- Verify callback URLs in GitHub/Twitter apps
- Check CORS settings in backend
- Verify client IDs in .env

### Issue: Contract calls failing
- Check wallet has MATIC
- Verify contract addresses
- Check Alchemy API key
- Test on Polygon Amoy explorer

---

## 🔒 SECURITY CHECKLIST

- [ ] .env files not committed to git
- [ ] Private keys secured
- [ ] CORS properly configured
- [ ] Rate limiting active
- [ ] SSL certificate valid
- [ ] MongoDB not exposed publicly
- [ ] API keys rotated regularly

---

## 📈 SUCCESS METRICS FOR USER TESTING

### Week 1 Goals
- [ ] 10+ users connected wallet
- [ ] 5+ badges minted
- [ ] 3+ passports created
- [ ] 1+ AI risk assessment generated
- [ ] 0 critical bugs

### Week 2 Goals
- [ ] 50+ users
- [ ] 20+ badges minted
- [ ] 10+ passports created
- [ ] 5+ API keys issued
- [ ] User feedback collected

---

## 📝 USER FEEDBACK FORM

Create a simple form to collect:
1. What worked well?
2. What didn't work?
3. Any errors encountered?
4. Feature requests?
5. Overall experience (1-5 stars)

---

## 🚀 QUICK DEPLOY SCRIPT

Save this as `deploy-for-testing.sh`:

```bash
#!/bin/bash
echo "🚀 Deploying Aura Protocol for User Testing"

# Build frontend
cd frontend
yarn build
tar -czf build.tar.gz build/

# Upload to VPS
scp build.tar.gz root@103.127.132.132:/tmp/

# Deploy on VPS
ssh root@103.127.132.132 << 'ENDSSH'
  # Update backend
  cd /root/Aura-Protocol-V.1-main
  git pull
  systemctl restart aura-backend
  
  # Update frontend
  cd /var/www/aurapass.xyz
  rm -rf *
  tar -xzf /tmp/build.tar.gz --strip-components=1
  chown -R www-data:www-data .
  chmod -R 755 .
  nginx -t && systemctl reload nginx
  
  echo "✅ Deployment complete!"
ENDSSH

echo "🎉 Done! Visit https://www.aurapass.xyz/"
```

---

## 📞 SUPPORT DURING TESTING

### For Users
- Discord/Telegram channel for support
- FAQ page on website
- Video tutorial (optional)

### For Developers
- Monitor logs in real-time
- Quick response to bug reports
- Daily status updates

---

## 🎯 NEXT STEPS AFTER TESTING

1. **Collect Feedback** - Analyze user feedback
2. **Fix Bugs** - Address critical issues
3. **Optimize** - Improve performance
4. **Scale** - Prepare for more users
5. **Mainnet** - Plan mainnet deployment

---

**Ready to deploy?** Run: `./deploy-for-testing.sh`

