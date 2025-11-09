# Enable Cloudflare Development Mode

## Problem
Cache purge tidak cukup - Cloudflare masih serve file lama.

## Solution: Development Mode (Instant Bypass)

### Steps:
1. Login: https://dash.cloudflare.com
2. Select: **aurapass.xyz**
3. Click: **Caching** (left sidebar)
4. Find: **Development Mode** section
5. Toggle: **ON** (switch to right)
6. Status: "Development Mode is on for 3 hours"

### What it does:
- Bypasses ALL cache instantly
- Serves files directly from VPS
- Auto-disables after 3 hours
- Perfect for testing deployments

### After enabling:
1. Wait 10 seconds
2. Hard refresh: Cmd+Shift+R
3. Check: https://www.aurapass.xyz/passport
4. Should see: AI Risk Oracle section

### Verify:
```bash
curl -s https://www.aurapass.xyz/ | grep -o "main\.[a-z0-9]*\.js"
```

Should return: `main.b65e0522.js` (NEW)

### Alternative: Purge by URL
If Development Mode not available:

1. Cloudflare → Caching → Custom Purge
2. Purge by URL:
   - https://www.aurapass.xyz/
   - https://www.aurapass.xyz/index.html
   - https://www.aurapass.xyz/static/js/main.a78dda41.js
3. Submit

## Status
- ✅ VPS: main.b65e0522.js (NEW - with AI Risk Oracle)
- ❌ Cloudflare: Serving main.a78dda41.js (OLD - cached)
- 🔄 Solution: Enable Development Mode

## Timeline
- Development Mode: Instant
- Cache purge propagation: 5-30 minutes
- Natural cache expiry: 24-48 hours
