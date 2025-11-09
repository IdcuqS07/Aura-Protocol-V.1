# 🚀 DEPLOYMENT SEKARANG - STEP BY STEP

**Status**: Ready to deploy  
**Time**: ~30 minutes  
**Date**: January 2025

---

## ✅ STEP 1: SETUP OAUTH CREDENTIALS (5 menit)

### A. GitHub OAuth App (REQUIRED)

1. **Buka**: https://github.com/settings/developers
2. **Klik**: "New OAuth App"
3. **Isi form**:
   ```
   Application name: Aura Protocol
   Homepage URL: https://www.aurapass.xyz
   Authorization callback URL: https://www.aurapass.xyz/api/poh/callback
   ```
4. **Klik**: "Register application"
5. **Copy**: Client ID dan Client Secret

### B. Alchemy API Key (REQUIRED)

1. **Buka**: https://www.alchemy.com/
2. **Sign up** atau login
3. **Create new app**:
   - Name: Aura Protocol
   - Chain: Polygon
   - Network: Polygon Amoy
4. **Copy**: API Key

### C. Update Backend .env

```bash
cd backend
nano .env
```

**Paste ini dan ganti dengan credentials Anda**:
```env
# MongoDB
MONGO_URL=mongodb://localhost:27017
DB_NAME=aura_protocol

# OAuth - GANTI DENGAN CREDENTIALS ANDA
GITHUB_CLIENT_ID=your_github_client_id_here
GITHUB_CLIENT_SECRET=your_github_client_secret_here
TWITTER_CLIENT_ID=optional
TWITTER_CLIENT_SECRET=optional

# Blockchain - GANTI DENGAN API KEY ANDA
ALCHEMY_API_KEY=your_alchemy_api_key_here
PRIVATE_KEY=your_wallet_private_key_here

# CORS
CORS_ORIGINS=https://www.aurapass.xyz,http://localhost:3000

# Contracts (sudah deployed)
BADGE_CONTRACT_ADDRESS=0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678
PASSPORT_CONTRACT_ADDRESS=0x1112373c9954B9bbFd91eb21175699b609A1b551
PROOF_REGISTRY_ADDRESS=0x296DB144E62C8C826bffA4503Dc9Fbf29F25D44B
```

**Save**: Ctrl+O, Enter, Ctrl+X

---

## ✅ STEP 2: BUILD FRONTEND (5 menit)

```bash
cd frontend

# Install dependencies (jika belum)
yarn install

# Build production
yarn build

# Create tarball
cd build
tar -czf ../build.tar.gz .
cd ..

# Verify
ls -lh build.tar.gz
```

**Expected**: File `build.tar.gz` sekitar 1-5 MB

---

## ✅ STEP 3: DEPLOY TO VPS (10 menit)

### A. Upload Frontend

```bash
# From project root
scp frontend/build.tar.gz root@103.127.132.132:/tmp/
```

**Enter password** saat diminta

### B. Update Backend & Deploy

```bash
# SSH to VPS
ssh root@103.127.132.132
```

**Setelah masuk VPS, jalankan**:

```bash
# Update backend code
cd /root/Aura-Protocol-V.1-main
git pull origin main

# Update .env dengan credentials Anda
nano backend/.env
# Paste credentials yang sama seperti di local
# Save: Ctrl+O, Enter, Ctrl+X

# Restart backend
systemctl restart aura-backend
systemctl status aura-backend

# Deploy frontend
cd /var/www/aurapass.xyz
rm -rf *
tar -xzf /tmp/build.tar.gz
chown -R www-data:www-data .
chmod -R 755 .

# Reload nginx
nginx -t && systemctl reload nginx

# Cleanup
rm -f /tmp/build.tar.gz

# Exit VPS
exit
```

---

## ✅ STEP 4: VERIFY DEPLOYMENT (5 menit)

### A. Test Backend API

```bash
# Test root endpoint
curl https://www.aurapass.xyz/api/

# Test analytics
curl https://www.aurapass.xyz/api/analytics

# Test oracle stats
curl https://www.aurapass.xyz/api/oracle/stats
```

**Expected**: JSON responses dengan status 200

### B. Test Frontend

```bash
# Open in browser
open https://www.aurapass.xyz/
```

**Manual checks**:
1. ✅ Site loads without errors
2. ✅ Can see homepage
3. ✅ Navigation works
4. ✅ Connect wallet button visible

### C. Test Full Flow

1. **Connect Wallet**:
   - Click "Connect Wallet"
   - Approve MetaMask
   - See address in header

2. **Try Badge Minting**:
   - Go to "Get Started"
   - Click "Mint Badge"
   - Approve transaction
   - Wait for confirmation

3. **Check Credit Passport**:
   - Go to "Credit Passport"
   - See your score (if you have badges)
   - Try "Mint Passport" if available

4. **Test AI Oracle**:
   - On Credit Passport page
   - Scroll to AI Risk Oracle
   - Click "Generate AI Risk Assessment"
   - See risk analysis

---

## ✅ STEP 5: MONITORING (Ongoing)

### Watch Logs

```bash
# SSH to VPS
ssh root@103.127.132.132

# Watch backend logs
tail -f /root/Aura-Protocol-V.1-main/backend/backend.log

# Watch nginx access
tail -f /var/log/nginx/access.log

# Watch nginx errors
tail -f /var/log/nginx/error.log
```

### Check Database

```bash
# Connect to MongoDB
mongo aura_protocol

# Check collections
show collections

# Count documents
db.badges.count()
db.passports.count()
db.enrollments.count()

# View recent activity
db.badges.find().sort({created_at: -1}).limit(5).pretty()
```

---

## 🐛 TROUBLESHOOTING

### Backend not starting?

```bash
ssh root@103.127.132.132
cd /root/Aura-Protocol-V.1-main/backend
source venv/bin/activate
python -c "import fastapi; print('OK')"
systemctl restart aura-backend
journalctl -u aura-backend -n 50
```

### Frontend not loading?

```bash
ssh root@103.127.132.132
ls -la /var/www/aurapass.xyz/
nginx -t
systemctl status nginx
tail -f /var/log/nginx/error.log
```

### OAuth not working?

1. Check callback URL in GitHub app
2. Verify credentials in backend/.env
3. Check CORS settings
4. Restart backend: `systemctl restart aura-backend`

---

## 🎉 DEPLOYMENT COMPLETE!

### ✅ Checklist

- [ ] OAuth credentials configured
- [ ] Frontend built and uploaded
- [ ] Backend updated and restarted
- [ ] Frontend deployed to nginx
- [ ] All services verified
- [ ] Manual testing passed

### 📱 URLs

- **Frontend**: https://www.aurapass.xyz/
- **Backend API**: https://www.aurapass.xyz/api/
- **Analytics**: https://www.aurapass.xyz/api/analytics
- **Oracle Stats**: https://www.aurapass.xyz/api/oracle/stats

---

## 🧪 NEXT: INVITE BETA TESTERS

### Message Template

```
🎉 You're invited to test Aura Protocol!

Aura Protocol is a decentralized credibility layer that builds 
ZK Credit Passports on Polygon.

🔗 Test Site: https://www.aurapass.xyz/

What to test:
✅ Connect your MetaMask wallet
✅ Mint a ZK-ID badge
✅ Create your Credit Passport
✅ Try the AI Risk Oracle

Requirements:
- MetaMask wallet
- Polygon Amoy testnet
- Test MATIC (get from faucet)

Feedback: [Create Google Form]
Support: [Discord/Telegram]

Happy testing! 🚀
```

### Where to find testers:

1. **Twitter/X**: Post announcement
2. **Discord**: Web3 communities
3. **Telegram**: Crypto groups
4. **Friends**: Personal network
5. **Reddit**: r/ethereum, r/polygon

---

## 📊 MONITORING METRICS

### Daily Checks

```bash
# User activity
mongo aura_protocol --eval "db.badges.count()"
mongo aura_protocol --eval "db.passports.count()"

# Recent badges
mongo aura_protocol --eval "db.badges.find().sort({created_at:-1}).limit(5)"

# Backend status
systemctl status aura-backend

# Nginx status
systemctl status nginx
```

### Success Metrics (Week 1)

- [ ] 10+ users connected wallet
- [ ] 5+ badges minted
- [ ] 3+ passports created
- [ ] 1+ AI assessment generated
- [ ] 0 critical bugs

---

## 🚀 YOU'RE LIVE!

**Congratulations!** Aura Protocol is now deployed and ready for user testing!

**Next steps**:
1. ✅ Monitor logs for errors
2. ✅ Invite beta testers
3. ✅ Collect feedback
4. ✅ Fix bugs quickly
5. ✅ Iterate and improve

**Good luck!** 🎉

