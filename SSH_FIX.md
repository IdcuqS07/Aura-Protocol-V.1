# 🔑 SSH Authentication Fix

## Issue
Password authentication failing. VPS likely uses SSH key authentication.

## Solution Options

### Option 1: Use SSH Key (Recommended)
```bash
# If you have SSH key configured
ssh -i ~/.ssh/id_rsa root@165.232.166.78

# Or if using different key
ssh -i /path/to/your/key root@165.232.166.78
```

### Option 2: Find Your SSH Key
```bash
# Check for existing SSH keys
ls -la ~/.ssh/

# Common key names:
# - id_rsa (private key)
# - id_ed25519 (private key)
# - id_ecdsa (private key)
```

### Option 3: Use Existing SSH Config
```bash
# Check if you have SSH config
cat ~/.ssh/config

# If configured, just use:
ssh aura-vps  # or whatever alias you have
```

### Option 4: Manual Deployment (No SSH Script)

Since SSH is having issues, deploy manually:

```bash
# 1. SSH to VPS (however you normally connect)
# If you have SSH key:
ssh -i ~/.ssh/your_key root@165.232.166.78

# 2. Once connected, run these commands:
cd /var/www/aura-backend-new
git pull origin main
pm2 delete aura-backend
pm2 start "uvicorn server:app --host 0.0.0.0 --port 9000" --name aura-backend
pm2 save
lsof -i :9000
curl http://localhost:9000/api/
```

## Quick Manual Deploy

**Just copy-paste these commands after SSH:**

```bash
cd /var/www/aura-backend-new && \
git pull origin main && \
pm2 delete aura-backend && \
pm2 start "uvicorn server:app --host 0.0.0.0 --port 9000" --name aura-backend && \
pm2 save && \
echo "✅ Deployed!" && \
lsof -i :9000 && \
curl http://localhost:9000/api/
```

## Alternative: Use Your Existing SSH Method

You've been connecting to the VPS before. Use the same method you used previously:
- SSH key file
- SSH config alias
- Password manager
- Terminal saved session

Then just run the deployment commands manually.
