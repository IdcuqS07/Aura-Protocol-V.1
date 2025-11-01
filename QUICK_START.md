# 🚀 Aura Protocol - Quick Start Guide

## ✅ Services Running

All services are now running and ready to use!

### 🟢 Active Services

| Service | Status | URL | PID |
|---------|--------|-----|-----|
| MongoDB | ✅ Running | localhost:27017 | - |
| Backend API | ✅ Running | http://localhost:9000 | Check with `lsof -ti:9000` |
| Frontend | ✅ Running | http://localhost:3000 | Check with `lsof -ti:3000` |

---

## 🌐 Access Points

### Frontend Application
```
http://localhost:3000
```
Main application interface - Connect wallet, mint badges, view passport

### Backend API Documentation
```
http://localhost:9000/docs
```
Interactive Swagger UI for API testing

### Backend API Base
```
http://localhost:9000/api
```
REST API endpoints

---

## 🎯 Quick Actions

### 1. Open Application
```bash
open http://localhost:3000
```

### 2. View API Docs
```bash
open http://localhost:9000/docs
```

### 3. Check Logs
```bash
# Backend logs
tail -f backend/backend.log

# Frontend logs
tail -f frontend/frontend.log
```

### 4. Stop Services
```bash
# Stop backend
kill $(lsof -ti:9000)

# Stop frontend
kill $(lsof -ti:3000)

# Stop MongoDB
brew services stop mongodb-community
```

### 5. Restart Services
```bash
# Backend
cd backend
source venv/bin/activate
uvicorn server:app --reload --port 9000

# Frontend
cd frontend
yarn start
```

---

## 🔗 Smart Contracts (Polygon Amoy)

- **SimpleZKBadge:** `0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678`
- **ProofRegistry:** `0x296DB144E62C8C826bffA4503Dc9Fbf29F25D44B`
- **Deployer:** `0xC3EcE9AC328CB232dDB0BC677d2e980a1a3D3974`

View on Explorer:
- https://amoy.polygonscan.com/address/0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678

---

## 🧪 Test the Application

1. **Connect Wallet**
   - Open http://localhost:3000
   - Click "Connect Wallet"
   - Switch to Polygon Amoy Testnet

2. **Mint Badge**
   - Go to "Mint Badge" page
   - Select badge type
   - Confirm transaction

3. **View Badges**
   - Check "Dashboard" for your badges
   - View on-chain data

4. **API Testing**
   - Open http://localhost:9000/docs
   - Try endpoints with Swagger UI

---

## 📊 Monitoring

### Check Service Status
```bash
# All services
lsof -i :3000,9000,27017

# Backend only
curl http://localhost:9000/docs

# Frontend only
curl http://localhost:3000
```

### View Logs in Real-time
```bash
# Backend
tail -f backend/backend.log

# Frontend
tail -f frontend/frontend.log
```

---

## ⚠️ Troubleshooting

### Port Already in Use
```bash
# Kill process on port 9000
kill $(lsof -ti:9000)

# Kill process on port 3000
kill $(lsof -ti:3000)
```

### MongoDB Not Running
```bash
brew services start mongodb-community
```

### Backend Issues
```bash
cd backend
source venv/bin/activate
pip install -r requirements.txt
uvicorn server:app --reload --port 9000
```

### Frontend Issues
```bash
cd frontend
yarn install
yarn start
```

---

## 🎉 You're All Set!

Application is ready at: **http://localhost:3000**

Happy building! 🚀
