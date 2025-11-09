# 🚀 Operational Tasks - Execution Plan

## 📋 Tasks Remaining

### 1. Deploy Frontend to VPS ⏳
### 2. Update Production `.env` ⏳
### 3. Test Production Environment ⏳
### 4. Test API Endpoints ⏳

---

## ✅ TASK 1: Build Frontend

**Status**: Ready to execute

```bash
cd frontend
yarn build
```

**Expected Output**: `build/` folder with production files

---

## ✅ TASK 2: Deploy to VPS

**Commands to run on VPS**:

```bash
# SSH to VPS
ssh root@159.65.134.137

# Navigate to project
cd /root/Aura-Protocol-V.1-main

# Pull latest changes
git pull origin main

# Build frontend
cd frontend
yarn install
yarn build

# Restart backend
cd ../backend
pm2 restart aura-backend || pm2 start server.py --name aura-backend --interpreter python3

# Check status
pm2 status
pm2 logs aura-backend --lines 20
```

---

## ✅ TASK 3: Verify Production `.env`

**Backend `.env` should have**:
```bash
MONGO_URL=mongodb://localhost:27017
DB_NAME=aura_protocol
CORS_ORIGINS=*
PRIVATE_KEY=<your_private_key>
RPC_URL=https://rpc-amoy.polygon.technology
GITHUB_CLIENT_ID=<your_github_client_id>
GITHUB_CLIENT_SECRET=<your_github_client_secret>
TWITTER_CLIENT_ID=<your_twitter_client_id>
TWITTER_CLIENT_SECRET=<your_twitter_client_secret>
ALCHEMY_API_KEY=<your_alchemy_key>
```

**Frontend `.env` should have**:
```bash
REACT_APP_BACKEND_URL=http://159.65.134.137:9000
REACT_APP_GITHUB_CLIENT_ID=Ov23liBkJpXGppFuyWWV
REACT_APP_TWITTER_CLIENT_ID=ZkNHUnEwSk5STWtKRWk2cW1fQWU6MTpjaQ
REACT_APP_CHAIN_ID=80002
REACT_APP_BADGE_CONTRACT=0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678
REACT_APP_PASSPORT_CONTRACT=0x1112373c9954B9bbFd91eb21175699b609A1b551
REACT_APP_PROOF_REGISTRY=0x296DB144E62C8C826bffA4503Dc9Fbf29F25D44B
```

---

## ✅ TASK 4: Test Production

### Backend Health Check
```bash
curl http://159.65.134.137:9000/api/
```

**Expected**: `{"message": "Aura Protocol API", "version": "1.0.0"}`

### Test Analytics
```bash
curl http://159.65.134.137:9000/api/analytics
```

### Test PoH Endpoints
```bash
# Test PoH enroll endpoint exists
curl -X POST http://159.65.134.137:9000/api/poh/enroll \
  -H "Content-Type: application/json" \
  -d '{"user_id": "test", "wallet_address": "0x123"}'
```

### Test Oracle Endpoints
```bash
# Test risk score endpoint
curl -X POST http://159.65.134.137:9000/api/oracle/risk-score \
  -H "Content-Type: application/json" \
  -d '{"wallet_address": "0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"}'
```

### Test Passport Endpoints
```bash
# Test passport score endpoint
curl http://159.65.134.137:9000/api/passport/score/0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1
```

---

## ✅ TASK 5: Frontend Testing Checklist

Visit: https://www.aurapass.xyz

- [ ] Homepage loads
- [ ] Connect wallet works
- [ ] Navigate to /verify (PoH page)
- [ ] Navigate to /passport (Credit Passport)
- [ ] Navigate to /oracle (Risk Oracle)
- [ ] Navigate to /analytics
- [ ] Check browser console for errors
- [ ] Test wallet connection
- [ ] Test PoH OAuth buttons (GitHub/Twitter)

---

## 🎯 Quick Deployment Script

Save this as `deploy-now.sh`:

```bash
#!/bin/bash

echo "🚀 Deploying Aura Protocol..."

# Build frontend locally
echo "📦 Building frontend..."
cd frontend
yarn build
cd ..

echo "✅ Frontend built successfully!"
echo ""
echo "📤 Next steps:"
echo "1. SSH to VPS: ssh root@159.65.134.137"
echo "2. Run: cd /root/Aura-Protocol-V.1-main && git pull"
echo "3. Run: cd frontend && yarn install && yarn build"
echo "4. Run: cd ../backend && pm2 restart aura-backend"
echo "5. Test: curl http://159.65.134.137:9000/api/"
echo ""
echo "🌐 Visit: https://www.aurapass.xyz"
```

---

## 📊 Success Criteria

### Backend ✅
- [ ] Server responds on port 9000
- [ ] All API endpoints return 200 or valid responses
- [ ] MongoDB connected
- [ ] PM2 shows running status

### Frontend ✅
- [ ] Website loads at https://www.aurapass.xyz
- [ ] No console errors
- [ ] Wallet connection works
- [ ] All pages accessible

### Integration ✅
- [ ] Frontend can call backend APIs
- [ ] PoH flow works end-to-end
- [ ] Credit Passport displays data
- [ ] Risk Oracle generates scores

---

## 🔧 Troubleshooting

### Backend Not Starting
```bash
# Check logs
pm2 logs aura-backend

# Restart
pm2 restart aura-backend

# Check port
lsof -i :9000
```

### Frontend Build Fails
```bash
# Clear cache
rm -rf node_modules build
yarn install
yarn build
```

### CORS Errors
```bash
# Update backend .env
CORS_ORIGINS=*

# Restart backend
pm2 restart aura-backend
```

---

**Ready to execute**: Yes ✅  
**Estimated time**: 10-15 minutes  
**Risk level**: Low
