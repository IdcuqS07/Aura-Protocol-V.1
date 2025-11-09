# 🚀 Quick Deploy Guide

## ⚡ One-Command Deploy

```bash
# SSH to VPS and run this:
cd /root/Aura-Protocol-V.1-main && \
git pull origin main && \
cd frontend && \
yarn install && \
yarn build && \
pm2 restart all && \
echo "✅ Deployment complete!"
```

## 📋 Step-by-Step (If Above Fails)

### 1. SSH to VPS
```bash
ssh root@159.65.134.137
```

### 2. Navigate to Project
```bash
cd /root/Aura-Protocol-V.1-main
```

### 3. Pull Latest Changes
```bash
git pull origin main
```

### 4. Build Frontend
```bash
cd frontend
yarn install
yarn build
```

### 5. Restart Services
```bash
# Option A: PM2
pm2 restart all

# Option B: Nginx
sudo systemctl restart nginx

# Option C: Both
pm2 restart all && sudo systemctl restart nginx
```

## ✅ Verify Deployment

1. Visit: https://www.aurapass.xyz
2. Press F12 (open console)
3. Check Network tab
4. Verify API calls go to: `http://159.65.134.137:9000`

## 🔧 Troubleshooting

### Build Fails
```bash
# Clear cache and rebuild
cd frontend
rm -rf node_modules
rm -rf build
yarn install
yarn build
```

### Services Not Starting
```bash
# Check PM2 status
pm2 status
pm2 logs

# Restart specific service
pm2 restart backend
pm2 restart frontend
```

### Port Already in Use
```bash
# Find process using port 9000
lsof -i :9000

# Kill process
kill -9 <PID>

# Restart service
pm2 restart backend
```

## 📊 Quick Checks

### Backend Health
```bash
curl http://159.65.134.137:9000/api/health
```

### Frontend Build Size
```bash
cd frontend/build
du -sh .
```

### PM2 Status
```bash
pm2 status
pm2 logs --lines 50
```

## 🔗 Important URLs

- **Frontend**: https://www.aurapass.xyz
- **Backend**: http://159.65.134.137:9000
- **Backend Health**: http://159.65.134.137:9000/api/health
- **PolygonScan**: https://amoy.polygonscan.com

## 📝 Files Changed (This Update)

1. `frontend/.env` - Backend URL updated
2. `frontend/src/config/api.js` - New config file
3. `frontend/src/components/RiskOracle.js` - Fallback fixed
4. `frontend/src/components/ProofOfHumanity.js` - Fallback fixed

## 🎯 What Was Fixed

- ✅ Removed localhost hardcoding
- ✅ Added production backend URL to `.env`
- ✅ Created centralized API config
- ✅ Updated component fallbacks

## ⚠️ Common Mistakes to Avoid

1. ❌ Don't forget to run `yarn build` after changes
2. ❌ Don't forget to restart services
3. ❌ Don't commit `.env` file
4. ❌ Don't test only on localhost

## 💡 Pro Tips

- Always test `yarn build` locally first
- Check browser console after deploy
- Monitor PM2 logs: `pm2 logs --lines 100`
- Keep `.env` file backed up separately

---

**Last Updated**: January 2025
**Status**: ✅ Ready to deploy
