# Cloudflare Cache Purge Guide

## Problem
AI Risk Oracle sudah deployed ke VPS tapi tidak muncul karena Cloudflare cache file lama.

## Evidence
- VPS serve: `main.b610ff65.js` (NEW - dengan AI Risk Oracle)
- Browser dapat: `main.a78dda41.js` (OLD - tanpa AI Risk Oracle)
- Cloudflare header: `server: cloudflare`, `cf-cache-status: DYNAMIC`

## Solution 1: Purge via Dashboard (RECOMMENDED)

1. Login ke https://dash.cloudflare.com
2. Pilih domain **aurapass.xyz**
3. Klik **Caching** → **Configuration**
4. Klik **Purge Everything**
5. Confirm purge
6. Tunggu 30-60 detik
7. Hard refresh browser (Ctrl+Shift+R atau Cmd+Shift+R)

## Solution 2: Purge via API

```bash
# Get your Cloudflare credentials:
# - Zone ID: dari Cloudflare dashboard → Overview
# - API Token: dari Cloudflare dashboard → My Profile → API Tokens

curl -X POST "https://api.cloudflare.com/client/v4/zones/{ZONE_ID}/purge_cache" \
  -H "Authorization: Bearer {API_TOKEN}" \
  -H "Content-Type: application/json" \
  --data '{"purge_everything":true}'
```

## Solution 3: Purge Specific Files

```bash
curl -X POST "https://api.cloudflare.com/client/v4/zones/{ZONE_ID}/purge_cache" \
  -H "Authorization: Bearer {API_TOKEN}" \
  -H "Content-Type: application/json" \
  --data '{
    "files": [
      "https://www.aurapass.xyz/",
      "https://www.aurapass.xyz/index.html",
      "https://www.aurapass.xyz/static/js/main.b610ff65.js"
    ]
  }'
```

## Solution 4: Development Mode (Temporary)

1. Cloudflare dashboard → **Caching** → **Configuration**
2. Enable **Development Mode** (bypasses cache for 3 hours)
3. Test site
4. Disable when done

## Verification

After purge, verify:

```bash
# Check which JS file is served
curl -s https://www.aurapass.xyz/ | grep -o "main\.[a-z0-9]*\.js"
# Should return: main.b610ff65.js

# Check for AI Risk Oracle in JS
curl -s https://www.aurapass.xyz/static/js/main.b610ff65.js | grep -o "AI Risk Oracle" | wc -l
# Should return: 8
```

## Prevention

Add cache-busting headers in Nginx:

```nginx
location / {
    root /var/www/aurapass.xyz;
    try_files $uri $uri/ /index.html;
    
    # Cache busting for HTML
    location ~* \.html$ {
        add_header Cache-Control "no-cache, no-store, must-revalidate";
        add_header Pragma "no-cache";
        add_header Expires "0";
    }
}
```

Then reload Nginx:
```bash
nginx -t && systemctl reload nginx
```

## Status

✅ VPS deployment: COMPLETE  
⏳ Cloudflare cache: NEEDS PURGE  
✅ Backend API: WORKING  
✅ Code verification: AI Risk Oracle present (8 occurrences)

**Next Step**: Purge Cloudflare cache via dashboard
