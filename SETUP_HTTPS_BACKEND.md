# Setup HTTPS for Backend API

## Problem
Frontend (HTTPS) cannot call backend (HTTP) - Mixed Content error

## Solution
Setup HTTPS reverse proxy for backend API

## Steps

### 1. SSH to Backend Server
```bash
ssh root@159.65.134.137
```

### 2. Install Certbot
```bash
apt update
apt install -y certbot python3-certbot-nginx
```

### 3. Setup DNS
Add A record: `api.aurapass.xyz` → `159.65.134.137`

### 4. Copy Nginx Config
```bash
# Upload config
scp backend/nginx-api.conf root@159.65.134.137:/etc/nginx/sites-available/api.aurapass.xyz

# Enable site
ln -s /etc/nginx/sites-available/api.aurapass.xyz /etc/nginx/sites-enabled/
```

### 5. Get SSL Certificate
```bash
certbot --nginx -d api.aurapass.xyz
```

### 6. Test & Reload
```bash
nginx -t
systemctl reload nginx
```

### 7. Rebuild & Redeploy Frontend
```bash
cd frontend
yarn build
tar czf build.tar.gz build/
scp build.tar.gz root@103.127.132.132:/tmp/

# On frontend server
ssh root@103.127.132.132
cd /var/www/aurapass.xyz
rm -rf *
tar xzf /tmp/build.tar.gz
mv build/* .
rmdir build
chown -R www-data:www-data /var/www/aurapass.xyz
systemctl reload nginx
```

## Verify
- Backend: https://api.aurapass.xyz/
- Frontend: https://www.aurapass.xyz/passport
- No Mixed Content errors
