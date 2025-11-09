# 🚀 Deploy PoH to VPS - Quick Guide

## ⚠️ Problem
PoH enrollment fails on VPS: "Not found"

## ✅ Solution
Deploy updated backend with PoH routes

---

## 📋 Steps (5 minutes)

### 1. SSH to VPS
```bash
ssh root@159.65.134.137
# Or your VPS IP
```

### 2. Navigate to Backend
```bash
cd /var/www/aura-backend-new
# Or wherever your backend is
```

### 3. Pull Latest Code
```bash
git pull origin main
```

### 4. Check New Files Exist
```bash
ls -la | grep poh
ls -la | grep github
ls -la | grep twitter
ls -la | grep onchain
ls -la | grep polygon_id
ls -la | grep credit_scoring
```

**Should see:**
- `poh_routes.py`
- `github_service.py`
- `twitter_service.py`
- `onchain_service.py`
- `polygon_id_service.py`
- `credit_scoring.py`

### 5. Install New Dependencies (if any)
```bash
source venv/bin/activate
pip install httpx  # For OAuth services
```

### 6. Update .env (Important!)
```bash
nano .env
```

**Add these if missing:**
```bash
# OAuth Configuration
GITHUB_CLIENT_ID="Ov23liBkJpXGppFuyWWV"
GITHUB_CLIENT_SECRET="1c3fd4c78d4978e929c8a733808ab1a3b00e32a8"
TWITTER_CLIENT_ID="ZkNHUnEwSk5STWtKRWk2cW1fQWU6MTpjaQ"
TWITTER_CLIENT_SECRET="VNq-wJUUCs7Zj2dUnnFgGr_gjg9L6wCNa4xRHCdGoAee9QRWn6"

# Alchemy API
ALCHEMY_API_KEY="zsi543hMtnSrWUHEELNgR"
```

Save: `Ctrl+O`, `Enter`, `Ctrl+X`

### 7. Restart Backend
```bash
# If using PM2:
pm2 restart aura-backend

# If using systemd:
sudo systemctl restart aura-backend

# If running manually:
# Ctrl+C then:
uvicorn server:app --host 0.0.0.0 --port 9000
```

### 8. Test Backend
```bash
curl http://localhost:9000/api/
```

**Should return:**
```json
{
  "message": "Aura Protocol API",
  "version": "1.0.0"
}
```

### 9. Test PoH Endpoint
```bash
curl -X POST http://localhost:9000/api/poh/enroll \
  -H "Content-Type: application/json" \
  -d '{"user_id":"test","wallet_address":"0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"}'
```

**Should return:**
```json
{
  "success": true,
  "enrollment_id": "...",
  "score": 5
}
```

### 10. Test from Frontend
```bash
# Exit SSH
exit

# Open browser:
https://www.aurapass.xyz/poh
```

Try enrollment - should work now!

---

## 🐛 Troubleshooting

### Issue: "git pull" fails
```bash
# Stash local changes
git stash
git pull origin main
```

### Issue: "Module not found: httpx"
```bash
source venv/bin/activate
pip install httpx
pm2 restart aura-backend
```

### Issue: Backend won't start
```bash
# Check logs
pm2 logs aura-backend

# Or if systemd:
sudo journalctl -u aura-backend -f
```

### Issue: Still "Not found"
```bash
# Check if PoH routes loaded
curl http://localhost:9000/docs
# Look for /api/poh/enroll endpoint
```

---

## ✅ Success Checklist

- [ ] SSH to VPS
- [ ] Git pull successful
- [ ] New files exist
- [ ] .env updated
- [ ] Backend restarted
- [ ] `/api/` endpoint works
- [ ] `/api/poh/enroll` endpoint works
- [ ] Frontend can enroll

---

## 📝 Quick Commands

```bash
# All in one:
ssh root@159.65.134.137 << 'EOF'
cd /var/www/aura-backend-new
git pull origin main
source venv/bin/activate
pip install httpx
pm2 restart aura-backend
pm2 logs aura-backend --lines 20
EOF
```

---

## 🎯 After Deployment

1. Test on production: https://www.aurapass.xyz/poh
2. Try GitHub OAuth
3. Try Twitter OAuth
4. Complete enrollment
5. Mint badge

---

**Time Required:** 5 minutes
**Difficulty:** Easy 🟢
