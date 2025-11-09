# Restore Tampilan Bagus ke Production

## Situasi
- ✅ **Localhost**: Tampilan BAGUS (yang diinginkan) - dengan AI Risk Oracle
- ❌ **Production**: Tampilan LAMA (Cloudflare cache) - tanpa AI Risk Oracle

## Solusi: Disable Cloudflare Proxy Sementara

### Langkah-langkah:

1. **Login Cloudflare**: https://dash.cloudflare.com
2. **Pilih**: aurapass.xyz
3. **Klik**: DNS (sidebar kiri)
4. **Cari record**: www (atau @ untuk root)
5. **Klik orange cloud** → Ubah jadi **gray cloud** (DNS only)
6. **Tunggu**: 2-5 menit untuk propagasi DNS
7. **Test**: https://www.aurapass.xyz/passport
8. **Seharusnya**: Langsung dapat tampilan baru dari VPS

### Setelah Confirmed Bagus:

**Option A: Biarkan Gray (No Cloudflare)**
- Pro: Selalu dapat update terbaru
- Con: Tidak ada CDN caching, sedikit lebih lambat

**Option B: Enable Orange Lagi (With Cloudflare)**
- Pro: Lebih cepat dengan CDN
- Con: Perlu purge cache setiap deploy
- Solusi: Set cache rules untuk HTML files

### Set Cache Rules (Recommended):

Setelah enable orange cloud lagi:

1. Cloudflare → Rules → Page Rules
2. Create Page Rule:
   - URL: `www.aurapass.xyz/*.html`
   - Setting: Cache Level = Bypass
3. Create Page Rule:
   - URL: `www.aurapass.xyz/`
   - Setting: Cache Level = Bypass
4. Save

Ini akan membuat HTML files tidak di-cache, tapi static assets (JS/CSS/images) tetap di-cache.

## Verifikasi

```bash
# Check DNS mode
dig www.aurapass.xyz

# If gray cloud (DNS only):
# Answer will show VPS IP: 159.65.134.137

# If orange cloud (Proxied):
# Answer will show Cloudflare IP: 104.x.x.x or 172.x.x.x
```

## Timeline
- Disable Cloudflare: 2-5 minutes
- Enable back: 2-5 minutes
- Set cache rules: Instant

## Current Files on VPS
- ✅ main.b65e0522.js (NEW - with AI Risk Oracle)
- ✅ Backend APIs working
- ✅ All features deployed

Problem is ONLY Cloudflare cache serving old files.
