# 🔥 Cloudflare Cache Purge - URGENT

## Quick Purge (Do This Now!)

### Option 1: Purge Everything (Fastest)
1. Login to Cloudflare: https://dash.cloudflare.com
2. Select domain: **aurapass.xyz**
3. Go to: **Caching** → **Configuration**
4. Click: **Purge Everything**
5. Confirm: **Purge Everything**

### Option 2: Purge Specific URLs
1. Login to Cloudflare
2. Select: **aurapass.xyz**
3. Go to: **Caching** → **Configuration**
4. Click: **Custom Purge**
5. Enter URLs:
   ```
   https://www.aurapass.xyz/
   https://www.aurapass.xyz/passport
   https://www.aurapass.xyz/oracle
   https://www.aurapass.xyz/analytics
   https://www.aurapass.xyz/static/js/*
   ```
6. Click: **Purge**

## After Purge

1. Wait 30 seconds
2. Hard refresh browser: **Ctrl+Shift+R** (Windows) or **Cmd+Shift+R** (Mac)
3. Test pages:
   - https://www.aurapass.xyz/passport
   - https://www.aurapass.xyz/oracle
   - https://www.aurapass.xyz/analytics

## Verify Cache Cleared

Check response headers:
```bash
curl -I https://www.aurapass.xyz/ | grep -i "cf-cache"
```

Should show: `cf-cache-status: MISS` (first time after purge)

---

**Status**: ✅ Backend restarted, Frontend deployed, Ready for cache purge
