# 🚀 Deploy Frontend - Manual Guide

## 📊 Situation
- Frontend di VPS bukan git repo
- Perlu build di local, upload ke VPS

## ✅ Solution: Build Local → Upload to VPS

### **Step 1: Build Frontend Locally**
```bash
cd frontend
yarn install
REACT_APP_BACKEND_URL=https://www.aurapass.xyz yarn build
```

**Expected:** `build/` folder created

---

### **Step 2: Upload to VPS**

**Option A: Using SCP**
```bash
cd frontend
scp -r build/* root@159.65.134.137:/var/www/aurapass.xyz/
```

**Option B: Using rsync**
```bash
cd frontend
rsync -avz --delete build/ root@159.65.134.137:/var/www/aurapass.xyz/
```

---

### **Step 3: Set Permissions on VPS**
```bash
ssh root@159.65.134.137
chown -R www-data:www-data /var/www/aurapass.xyz
sudo systemctl reload nginx
exit
```

---

### **Step 4: Test**
```bash
curl https://www.aurapass.xyz/passport
```

Open browser:
- https://www.aurapass.xyz/passport
- https://www.aurapass.xyz/poh

---

## 🎯 Quick One-Liner

```bash
cd frontend && \
yarn build && \
rsync -avz --delete build/ root@159.65.134.137:/var/www/aurapass.xyz/ && \
ssh root@159.65.134.137 "chown -R www-data:www-data /var/www/aurapass.xyz && systemctl reload nginx"
```

---

## ⚠️ Alternative: Setup Git Repo on VPS

If you want automated deployment:

```bash
ssh root@159.65.134.137

# Remove old frontend
rm -rf /var/www/aura-frontend

# Clone fresh
cd /var/www
git clone https://github.com/IdcuqS07/Aura-Protocol-V.1.git aura-frontend-new
cd aura-frontend-new/frontend

# Build
yarn install
REACT_APP_BACKEND_URL=https://www.aurapass.xyz yarn build

# Deploy
rm -rf /var/www/aurapass.xyz/*
cp -r build/* /var/www/aurapass.xyz/
chown -R www-data:www-data /var/www/aurapass.xyz
systemctl reload nginx
```

---

**Time Required:** 5-10 minutes
**Recommended:** Option A (SCP) - Simplest
