# 🔐 OAuth Testing Guide

## ✅ Current Setup

Your `.env` already has:
- ✅ GitHub Client ID: `Ov23liBkJpXGppFuyWWV`
- ✅ Twitter Client ID: `ZkNHUnEwSk5STWtKRWk2cW1fQWU6MTpjaQ`
- ✅ Alchemy API Key: `zsi543hMtnSrWUHEELNgR`

## 🧪 Test OAuth Flow

### 1. Test GitHub OAuth

**Step 1:** Open browser and go to:
```
http://localhost:3000/poh
```

**Step 2:** Click "Connect GitHub"

**Expected:** Redirect to GitHub authorization page

**Step 3:** Authorize the app

**Expected:** Redirect back to `http://localhost:3000/poh/callback?code=...`

**Step 4:** Check console for code parameter

**Step 5:** Backend should exchange code for token and fetch GitHub data

---

### 2. Test Twitter OAuth

**Step 1:** Click "Connect Twitter"

**Expected:** Redirect to Twitter authorization page

**Step 2:** Authorize the app

**Expected:** Redirect back to `http://localhost:3000/poh/callback?code=...`

---

### 3. Verify OAuth Apps Settings

#### GitHub OAuth App
Go to: https://github.com/settings/developers

**Required Settings:**
- Homepage URL: `http://localhost:3000`
- Authorization callback URL: `http://localhost:3000/poh/callback`

**For Production:**
- Add callback: `https://www.aurapass.xyz/poh/callback`

#### Twitter OAuth App
Go to: https://developer.twitter.com/en/portal/dashboard

**Required Settings:**
- Callback URL: `http://localhost:3000/poh/callback`
- Website URL: `http://localhost:3000`

**For Production:**
- Add callback: `https://www.aurapass.xyz/poh/callback`

---

## 🔧 Test with Real OAuth

Run this test to verify OAuth works:

```bash
# Start backend
cd backend
source venv/bin/activate
uvicorn server:app --reload --port 9000

# Start frontend (new terminal)
cd frontend
yarn start
```

Then:
1. Go to http://localhost:3000/poh
2. Connect wallet
3. Click "Connect GitHub"
4. Authorize
5. Should redirect back with code
6. Click "Continue to Enrollment"
7. Should see higher score (20-40 from GitHub)

---

## 📊 Expected Scores

**Without OAuth:** 5-10 points (on-chain only)
**With GitHub:** 20-50 points
**With Twitter:** 30-60 points
**With Both:** 60-100 points

---

## 🐛 Troubleshooting

### Issue: "Redirect URI mismatch"
**Fix:** Update callback URL in GitHub/Twitter app settings

### Issue: "Invalid client"
**Fix:** Check Client ID and Secret in `.env`

### Issue: "Code already used"
**Fix:** OAuth codes are single-use, try again

### Issue: Score still low after OAuth
**Fix:** Check backend logs for OAuth errors

---

## ✅ Success Criteria

- [ ] GitHub OAuth redirects correctly
- [ ] Twitter OAuth redirects correctly
- [ ] Backend receives OAuth code
- [ ] Backend exchanges code for token
- [ ] Backend fetches user data
- [ ] Score increases (60-100)
- [ ] Badge mints successfully

---

## 🚀 Next: Production Setup

Once local OAuth works, update for production:

1. **GitHub App:**
   - Add callback: `https://www.aurapass.xyz/poh/callback`

2. **Twitter App:**
   - Add callback: `https://www.aurapass.xyz/poh/callback`

3. **Update Frontend `.env.production`:**
   ```
   REACT_APP_BACKEND_URL=https://www.aurapass.xyz
   REACT_APP_GITHUB_CLIENT_ID=Ov23liBkJpXGppFuyWWV
   REACT_APP_TWITTER_CLIENT_ID=ZkNHUnEwSk5STWtKRWk2cW1fQWU6MTpjaQ
   ```

4. **Deploy:**
   ```bash
   cd frontend
   yarn build
   # Upload to VPS
   ```
