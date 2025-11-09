# Quick Deployment Guide

## 🖥️ LOCAL DEVELOPMENT (Mac)

```bash
# Start frontend (connects to production backend)
cd /Users/idcuq/Documents/Akindo/Aura\ Protocol/Aura-Protocol-V.1-main/frontend
yarn start
# Opens http://localhost:3000
```

## 🚀 VPS DEPLOYMENT

### Backend Update
```bash
# SSH to VPS
ssh root@159.65.134.137

# Navigate to project
cd /root/Aura-Protocol-V.1-main/backend

# Pull latest code
git pull

# Restart backend
pm2 restart aura-backend

# Verify
curl http://159.65.134.137:9000/
```

### Frontend Update
```bash
# On Mac - Build frontend
cd /Users/idcuq/Documents/Akindo/Aura\ Protocol/Aura-Protocol-V.1-main/frontend
yarn build
tar czf build.tar.gz build/

# Upload to VPS
scp build.tar.gz root@159.65.134.137:/tmp/

# On VPS - Deploy
ssh root@159.65.134.137
cd /var/www/aurapass.xyz
rm -rf *
tar xzf /tmp/build.tar.gz
mv build/* .
rmdir build
chown -R www-data:www-data /var/www/aurapass.xyz
chmod -R 755 /var/www/aurapass.xyz
nginx -t && systemctl reload nginx
```

## 📊 SYSTEM STATUS

**Production URLs:**
- Frontend: https://www.aurapass.xyz
- Backend: http://159.65.134.137:9000
- API Docs: http://159.65.134.137:9000/docs

**Smart Contracts (Polygon Amoy):**
- SimpleZKBadge: `0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678`
- CreditPassport: `0x1112373c9954B9bbFd91eb21175699b609A1b551`
- ProofRegistry: `0x296DB144E62C8C826bffA4503Dc9Fbf29F25D44B`

## 🔍 MONITORING

```bash
# Check backend status
pm2 status
pm2 logs aura-backend

# Check MongoDB
systemctl status mongod

# Check Nginx
systemctl status nginx
nginx -t

# Test API
curl http://159.65.134.137:9000/api/analytics
```

## ✅ GELOMBANG 2 - 100% COMPLETE

All 5 phases deployed and operational! 🎉
