# ⚡ Quick Start: Proof of Humanity

## 🎯 Goal
Test PoH flow in 5 minutes

## 🚀 Steps

### 1. Start Everything (30 seconds)
```bash
# Terminal 1
cd backend && source venv/bin/activate && uvicorn server:app --reload --port 9000

# Terminal 2  
cd frontend && yarn start
```

### 2. Quick Test (1 minute)
```bash
# Terminal 3
bash test-poh.sh
```

**Expected Output:**
```
✅ Enrollment successful! Score: 5
✅ Proof generated!
✅ Badge issued! Token ID: 48
✅ Duplicate prevention working!
```

### 3. Check Dashboard (30 seconds)
Open: http://localhost:3000/dashboard

**Expected:** Badge appears in "Your Badges"

---

## 🎨 Full UI Test (3 minutes)

1. Go to: http://localhost:3000/poh
2. Connect wallet
3. Click "Continue to Enrollment" (skip OAuth for now)
4. See score: ~5/100
5. Click "Generate ZK Proof"
6. Click "Mint Soulbound Badge"
7. Success! 🎉

---

## 🔥 Test with Real OAuth (5 minutes)

### Setup (One-time)
1. **GitHub:** https://github.com/settings/developers
   - Callback: `http://localhost:3000/poh/callback`
   
2. **Twitter:** https://developer.twitter.com/portal
   - Callback: `http://localhost:3000/poh/callback`

### Test
1. Go to: http://localhost:3000/poh
2. Click "Connect GitHub" → Authorize
3. Click "Connect Twitter" → Authorize
4. Click "Continue to Enrollment"
5. Score should be 60-100! 🎯

---

## ✅ Success Criteria

- [ ] Backend running (port 9000)
- [ ] Frontend running (port 3000)
- [ ] Test script passes
- [ ] Badge shows in dashboard
- [ ] Score calculated correctly

---

## 🐛 Troubleshooting

**Backend not starting?**
```bash
cd backend
pip install -r requirements.txt
```

**Frontend not starting?**
```bash
cd frontend
yarn install
```

**MongoDB not running?**
```bash
brew services start mongodb-community
```

**Test fails?**
Check backend logs in Terminal 1

---

## 📊 What's Next?

✅ Phase 1 Complete → Choose:

1. **Deploy to Production** (Recommended)
2. **Improve Scoring** (Add more sources)
3. **Integrate Passport** (Auto-update credit score)
4. **Add Admin Panel** (Monitor enrollments)

---

**Time to complete:** 5 minutes ⚡
**Difficulty:** Easy 🟢
**Status:** Ready to test! 🚀
