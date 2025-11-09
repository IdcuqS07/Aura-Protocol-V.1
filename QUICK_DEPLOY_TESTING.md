# ⚡ QUICK DEPLOY FOR USER TESTING

**Time Required**: 30 minutes  
**Difficulty**: Easy  
**Prerequisites**: VPS access, OAuth credentials

---

## 🚀 3-STEP DEPLOYMENT

### Step 1: Setup OAuth (5 minutes)

```bash
# Run setup guide
./setup-oauth-credentials.sh
```

**What you need**:
1. GitHub OAuth App (REQUIRED)
   - Go to: https://github.com/settings/developers
   - Create new OAuth App
   - Callback URL: `https://www.aurapass.xyz/api/poh/callback`
   
2. Alchemy API Key (REQUIRED)
   - Go to: https://www.alchemy.com/
   - Create app on Polygon Amoy
   - Copy API key

3. Update `backend/.env` with your credentials

---

### Step 2: Deploy (10 minutes)

```bash
# Run deployment script
./deploy-for-testing.sh
```

**What it does**:
- ✅ Builds frontend
- ✅ Uploads to VPS
- ✅ Updates backend
- ✅ Restarts services
- ✅ Verifies deployment

---

### Step 3: Verify (5 minutes)

```bash
# Test backend
curl https://www.aurapass.xyz/api/

# Test frontend
open https://www.aurapass.xyz/

# Test analytics
curl https://www.aurapass.xyz/api/analytics
```

**Manual checks**:
1. Visit https://www.aurapass.xyz/
2. Connect wallet
3. Try minting a badge
4. Check credit passport page

---

## 🧪 START USER TESTING

### Invite Beta Testers

**Message Template**:
```
🎉 You're invited to test Aura Protocol!

Aura Protocol is a decentralized credibility layer that builds ZK Credit Passports.

🔗 Test Site: https://www.aurapass.xyz/

What to test:
✅ Connect your wallet (MetaMask)
✅ Mint a ZK-ID badge
✅ Create your Credit Passport
✅ Try the AI Risk Oracle

Requirements:
- MetaMask wallet
- Polygon Amoy testnet
- Test MATIC (from faucet)

Feedback Form: [Create Google Form]

Questions? Join our Discord: [Link]

Happy testing! 🚀
```

---

## 📊 MONITORING

### Real-time Logs

```bash
# SSH to VPS
ssh root@103.127.132.132

# Watch backend logs
tail -f /root/Aura-Protocol-V.1-main/backend/backend.log

# Watch nginx logs
tail -f /var/log/nginx/access.log
```

### Database Queries

```bash
# Connect to MongoDB
mongo aura_protocol

# Check activity
db.badges.count()
db.passports.count()
db.enrollments.count()
db.risk_predictions.count()

# Recent badges
db.badges.find().sort({created_at: -1}).limit(5).pretty()
```

---

## 🐛 QUICK FIXES

### Backend not responding
```bash
ssh root@103.127.132.132
systemctl restart aura-backend
systemctl status aura-backend
```

### Frontend not loading
```bash
ssh root@103.127.132.132
nginx -t
systemctl reload nginx
```

### OAuth not working
1. Check callback URL in GitHub app
2. Verify credentials in backend/.env
3. Restart backend service

---

## 📈 SUCCESS METRICS

### Day 1 Goals
- [ ] 5 users connected wallet
- [ ] 3 badges minted
- [ ] 1 passport created
- [ ] 0 critical bugs

### Week 1 Goals
- [ ] 20 users tested
- [ ] 10 badges minted
- [ ] 5 passports created
- [ ] User feedback collected

---

## 🎯 TESTING PRIORITIES

### Must Test (P0)
1. ✅ Wallet connection
2. ✅ Badge minting
3. ✅ Passport creation
4. ✅ AI risk oracle

### Should Test (P1)
1. ✅ GitHub OAuth
2. ✅ Score calculation
3. ✅ Analytics page
4. ✅ Mobile experience

### Nice to Test (P2)
1. ✅ API endpoints
2. ✅ Error handling
3. ✅ Edge cases

---

## 📞 SUPPORT

### For Testers
- **Issues**: Create GitHub issue
- **Questions**: Discord/Telegram
- **Feedback**: Google Form

### For Developers
- **Logs**: SSH to VPS
- **Database**: MongoDB queries
- **Monitoring**: Check systemctl status

---

## ✅ DEPLOYMENT CHECKLIST

Before inviting users:
- [ ] OAuth credentials configured
- [ ] Backend deployed and running
- [ ] Frontend deployed and accessible
- [ ] All services verified
- [ ] Monitoring setup
- [ ] Support channels ready
- [ ] Feedback form created
- [ ] Test MATIC available

---

## 🚀 READY TO DEPLOY?

```bash
# 1. Setup OAuth
./setup-oauth-credentials.sh

# 2. Deploy
./deploy-for-testing.sh

# 3. Verify
open https://www.aurapass.xyz/

# 4. Invite testers
# Send invitation message

# 5. Monitor
ssh root@103.127.132.132
tail -f /root/Aura-Protocol-V.1-main/backend/backend.log
```

---

## 📝 NOTES

- **Test MATIC**: Users need test MATIC from Polygon Amoy faucet
- **MetaMask**: Users must add Polygon Amoy network
- **Feedback**: Collect feedback daily
- **Bugs**: Fix critical bugs immediately
- **Updates**: Deploy fixes with `./deploy-for-testing.sh`

---

**Good luck with user testing!** 🎉

