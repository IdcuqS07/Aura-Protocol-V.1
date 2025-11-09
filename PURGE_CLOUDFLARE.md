# Purge Cloudflare Cache - URGENT

## Masalah
File baru sudah di VPS tapi Cloudflare serve file lama dari cache.

## Status
- ✅ VPS: `main.049a5338.js` (NEW - dengan fix passport minting)
- ❌ Browser: `main.a78dda41.js` atau `main.b610ff65.js` (OLD - dari Cloudflare cache)

## Solusi 1: Purge via Dashboard (5 menit)

1. **Login Cloudflare**: https://dash.cloudflare.com
2. **Pilih domain**: aurapass.xyz
3. **Klik**: Caching → Configuration
4. **Klik**: "Purge Everything" (button biru)
5. **Confirm**: Yes, purge everything
6. **Tunggu**: 30-60 detik
7. **Test**: Hard refresh browser (Cmd+Shift+R)

## Solusi 2: Development Mode (Instant - 3 jam)

1. **Cloudflare dashboard** → Caching
2. **Toggle ON**: Development Mode
3. **Refresh browser**: Langsung bypass cache
4. **Auto OFF**: Setelah 3 jam

## Solusi 3: Purge via API (Butuh API Token)

```bash
# Get Zone ID dari Cloudflare dashboard → Overview
ZONE_ID="your_zone_id"
API_TOKEN="your_api_token"

curl -X POST "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/purge_cache" \
  -H "Authorization: Bearer ${API_TOKEN}" \
  -H "Content-Type: application/json" \
  --data '{"purge_everything":true}'
```

## Solusi 4: Bypass Cloudflare (Testing Only)

Edit `/etc/hosts`:
```bash
sudo nano /etc/hosts

# Tambahkan:
159.65.134.137 www.aurapass.xyz

# Save dan flush DNS:
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
```

Sekarang browser akan langsung ke VPS, bypass Cloudflare.

**Restore:**
```bash
sudo sed -i '' '/159.65.134.137 www.aurapass.xyz/d' /etc/hosts
```

## Verifikasi

Setelah purge, cek file yang di-serve:

```bash
curl -s https://www.aurapass.xyz/ | grep -o "main\.[a-z0-9]*\.js"
```

**Expected**: `main.049a5338.js`

## Fix yang Sudah Deployed

File `main.049a5338.js` sudah fix:
- ✅ Extract `poh_score` dari `user_data.poh_score`
- ✅ Extract `badge_count` dari `user_data.badge_count`
- ✅ Passport minting akan berfungsi setelah cache di-purge

## Timeline

- **Purge manual**: 5 menit
- **Development Mode**: Instant (3 jam)
- **Auto cache expire**: 24-48 jam (terlalu lama)

## Rekomendasi

**GUNAKAN DEVELOPMENT MODE** - paling cepat dan mudah!

1. Cloudflare dashboard
2. Caching → Development Mode → ON
3. Refresh browser
4. Test mint passport
5. OFF setelah selesai testing
