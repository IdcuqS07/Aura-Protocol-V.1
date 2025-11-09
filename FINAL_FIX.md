# Final Fix - Cloudflare Cache Issue

## Problem
- VPS index.html: References `main.b65e0522.js` ✅
- Cloudflare serves: `main.a78dda41.js` ❌
- Development Mode: ON
- Cache Purge: Done
- Still serving old file

## Root Cause
Cloudflare has multiple cache layers. Even with Development Mode, some edge servers may still have old cache.

## Solution: Force Purge Specific Files

### Option 1: Purge by URL (RECOMMENDED)
1. Cloudflare Dashboard → aurapass.xyz
2. Caching → Custom Purge
3. Select: **Purge by URL**
4. Enter these URLs (one per line):
   ```
   https://www.aurapass.xyz/
   https://www.aurapass.xyz/index.html
   https://www.aurapass.xyz/static/js/main.a78dda41.js
   https://www.aurapass.xyz/static/js/main.b65e0522.js
   ```
5. Click: **Purge**
6. Wait: 30 seconds
7. Test: Hard refresh browser (Cmd+Shift+R)

### Option 2: Disable Cloudflare Temporarily
1. Cloudflare → DNS
2. Click orange cloud icon next to www record
3. Turn to gray (DNS only)
4. Wait 5 minutes for propagation
5. Test site - should work
6. Re-enable orange cloud when confirmed

### Option 3: Change Nginx to Prevent Caching
SSH to VPS and add no-cache headers:

```bash
ssh root@159.65.134.137
nano /etc/nginx/sites-available/aurapass.xyz
```

Add inside `location /` block:
```nginx
location / {
    root /var/www/aurapass.xyz;
    try_files $uri $uri/ /index.html;
    
    # Prevent caching for HTML
    location ~* \.html$ {
        add_header Cache-Control "no-cache, no-store, must-revalidate";
        add_header Pragma "no-cache";
        add_header Expires "0";
    }
}
```

Then:
```bash
nginx -t
systemctl reload nginx
```

### Option 4: Add Cache Buster to Deployment
Rename files with timestamp to force new cache:

```bash
# In future deployments
cd frontend/build
mv static/js/main.*.js static/js/main.$(date +%s).js
# Update index.html reference
```

## Verification Commands

```bash
# Check VPS file
ssh root@159.65.134.137 "ls -lh /var/www/aurapass.xyz/static/js/main.*.js"

# Check VPS index.html
ssh root@159.65.134.137 "grep -o 'main\.[a-z0-9]*\.js' /var/www/aurapass.xyz/index.html"

# Check what Cloudflare serves
curl -s https://www.aurapass.xyz/ | grep -o "main\.[a-z0-9]*\.js"

# Check with no-cache header
curl -s -H "Cache-Control: no-cache" https://www.aurapass.xyz/ | grep -o "main\.[a-z0-9]*\.js"
```

## Current Status
- ✅ Code: AI Risk Oracle implemented
- ✅ VPS: main.b65e0522.js deployed
- ✅ Backend: All APIs working
- ✅ Development Mode: Enabled
- ❌ Cloudflare: Still caching old file

## Next Steps
1. Try Option 1 (Purge by URL) - most reliable
2. If fails, try Option 2 (Disable Cloudflare temporarily)
3. If still fails, implement Option 3 (No-cache headers)

## Timeline
- Purge by URL: 1-5 minutes
- Disable Cloudflare: 5-10 minutes
- No-cache headers: Instant (but affects performance)
