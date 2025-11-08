# ✅ Verify Backend on Port 9000

Quick commands to verify backend is running on port 9000.

---

## 🔍 Quick Check

```bash
# SSH to VPS
ssh root@165.232.166.78

# Check PM2 status
pm2 status

# Check port 9000
lsof -i :9000

# Test API
curl http://localhost:9000/api/
```

---

## 📋 Expected Output

### PM2 Status
```
┌─────┬──────────────────┬─────────┬─────────┬──────────┬────────┬──────┐
│ id  │ name             │ status  │ restart │ uptime   │ cpu    │ mem  │
├─────┼──────────────────┼─────────┼─────────┼──────────┼────────┼──────┤
│ 1   │ aura-backend     │ online  │ 0       │ 2h       │ 0%     │ 50MB │
└─────┴──────────────────┴─────────┴─────────┴──────────┴────────┴──────┘
```

### Port 9000
```
COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
python3  1234 root    3u  IPv4  12345      0t0  TCP *:9000 (LISTEN)
```

### API Response
```json
{
  "message": "Aura Protocol API",
  "version": "1.0.0",
  "description": "Polygon ZK-ID Credit Layer"
}
```

---

## 🔧 If Backend NOT on Port 9000

### Check Current Port
```bash
# Find what port backend is using
ps aux | grep uvicorn
netstat -tulpn | grep python
```

### Restart on Port 9000
```bash
# Stop current process
pm2 delete aura-backend

# Start on port 9000
cd /var/www/aura-backend-new
pm2 start "uvicorn server:app --host 0.0.0.0 --port 9000" --name aura-backend

# Save PM2 config
pm2 save
```

### Verify
```bash
# Check PM2
pm2 status

# Check port
lsof -i :9000

# Test API
curl http://localhost:9000/api/
```

---

## 🌐 Check Nginx Proxy

Nginx should proxy requests to port 9000:

```bash
# Check nginx config
cat /etc/nginx/sites-available/aura-backend

# Should contain:
# proxy_pass http://localhost:9000;
```

### Test Nginx Proxy
```bash
# From VPS
curl http://localhost/api/

# From outside
curl https://api.aurapass.xyz/api/
```

---

## ✅ Verification Checklist

- [ ] PM2 shows `aura-backend` online
- [ ] Port 9000 is listening
- [ ] `curl http://localhost:9000/api/` returns JSON
- [ ] Nginx proxies to port 9000
- [ ] `curl https://api.aurapass.xyz/api/` works
- [ ] Site loads at https://www.aurapass.xyz/

---

## 🚀 Quick Fix Commands

```bash
# SSH to VPS
ssh root@165.232.166.78

# Navigate to backend
cd /var/www/aura-backend-new

# Stop all PM2 processes
pm2 delete all

# Start backend on port 9000
pm2 start "uvicorn server:app --host 0.0.0.0 --port 9000" --name aura-backend

# Save PM2 config
pm2 save

# Check status
pm2 status

# Check logs
pm2 logs aura-backend --lines 20

# Test API
curl http://localhost:9000/api/

# Test from outside
curl https://api.aurapass.xyz/api/
```

---

## 📊 Port Configuration

Backend should be configured as:

- **Host**: `0.0.0.0` (listen on all interfaces)
- **Port**: `9000` (internal port)
- **Nginx**: Proxies external requests to `localhost:9000`
- **External URL**: `https://api.aurapass.xyz` → `http://localhost:9000`

---

## ✅ Success Criteria

Backend is correctly configured when:

1. ✅ PM2 shows process online
2. ✅ Port 9000 is listening
3. ✅ Local curl works: `http://localhost:9000/api/`
4. ✅ External curl works: `https://api.aurapass.xyz/api/`
5. ✅ Site loads: `https://www.aurapass.xyz/`
6. ✅ No 502 Bad Gateway errors

---

> Backend must run on port 9000 for Nginx proxy to work correctly.
