# Deploy PoH Update to VPS

## Issue
VPS backend is running old `server.py` without PoH routes. Enrollment endpoint returns 404.

## Solution
Deploy updated backend files to VPS.

## Files to Deploy
1. `backend/server.py` - Updated with PoH router imports
2. `backend/poh_routes.py` - PoH endpoints
3. `backend/github_service.py` - GitHub OAuth
4. `backend/twitter_service.py` - Twitter OAuth
5. `backend/onchain_service.py` - On-chain data
6. `backend/polygon_id_service.py` - ZK proof generation

## Deployment Steps

### 1. SSH into VPS
```bash
ssh root@165.232.166.78
```

### 2. Navigate to Backend Directory
```bash
cd /var/www/aura-backend-new
```

### 3. Backup Current server.py
```bash
cp server.py server.py.backup
```

### 4. Pull Latest Code
```bash
git pull origin main
```

### 5. Check Files Exist
```bash
ls -la poh_routes.py github_service.py twitter_service.py onchain_service.py polygon_id_service.py
```

### 6. Restart Backend on Port 9000
```bash
pm2 delete aura-backend
pm2 start "uvicorn server:app --host 0.0.0.0 --port 9000" --name aura-backend
pm2 save
```

### 7. Verify Port 9000
```bash
lsof -i :9000
```

Expected: Should show python/uvicorn listening on port 9000

### 8. Check Logs
```bash
pm2 logs aura-backend --lines 50
```

### 9. Test API
```bash
curl http://localhost:9000/api/
```

Expected: Should return JSON with "Aura Protocol API"

### 10. Test PoH Endpoint
```bash
curl http://localhost:9000/api/poh/enroll
```

Expected: Should return error about missing fields (not 404)

### 9. Test from Frontend
Visit: https://www.aurapass.xyz/verify

## Environment Variables Needed

Add to `/var/www/aura-backend-new/.env`:

```bash
# GitHub OAuth
GITHUB_CLIENT_ID=your_github_client_id
GITHUB_CLIENT_SECRET=your_github_client_secret
GITHUB_REDIRECT_URI=https://api.aurapass.xyz/api/poh/callback

# Twitter OAuth
TWITTER_CLIENT_ID=your_twitter_client_id
TWITTER_CLIENT_SECRET=your_twitter_client_secret
TWITTER_REDIRECT_URI=https://api.aurapass.xyz/api/poh/callback

# Alchemy
ALCHEMY_API_KEY=your_alchemy_api_key
```

## Verification

After deployment, test the full flow:

1. Visit https://www.aurapass.xyz/verify
2. Click "Connect GitHub" - should redirect to GitHub OAuth
3. After auth, should return to site with code
4. Click "Connect Twitter" - should redirect to Twitter OAuth
5. Complete enrollment - should calculate score and generate proof
6. Mint badge - should create on-chain transaction

## Rollback (if needed)

```bash
cd /var/www/aura-backend-new
cp server.py.backup server.py
pm2 restart aura-backend
```

## Status Check

```bash
# Check PM2 status
pm2 status

# Check backend logs
pm2 logs aura-backend --lines 100

# Check if PoH routes loaded
curl http://localhost:9000/api/poh/enroll

# Check main API
curl http://localhost:9000/api/
```

## Notes

- PoH routes require OAuth credentials to work fully
- Without credentials, enrollment will fail at OAuth step
- Demo badges still work without PoH
- Credit Passport contract already deployed at `0x1112373c9954B9bbFd91eb21175699b609A1b551`
