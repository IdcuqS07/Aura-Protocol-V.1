# Final Solution - Disable Cloudflare

## Masalah
Cloudflare cache sangat persistent, tidak bisa di-purge dengan cara normal.

## Solusi: Disable Cloudflare Proxy

### Langkah:
1. Login: https://dash.cloudflare.com
2. Pilih: aurapass.xyz
3. Klik: **DNS**
4. Cari record: **www** (atau **@** untuk root domain)
5. Klik **orange cloud** ☁️ → Ubah jadi **gray cloud** ☁️
6. Save
7. Tunggu 5 menit untuk DNS propagation
8. Test: https://www.aurapass.xyz

## Hasil
- Traffic langsung ke VPS (159.65.134.137)
- Tidak ada cache Cloudflare
- Tampilan akan sesuai dengan file di VPS
- File di VPS sekarang: main.a78dda41.js (versi lama yang bagus)

## Setelah Confirmed Bagus
Bisa enable orange cloud lagi kalau mau, tapi set cache rules dulu.

## Status VPS Sekarang
```
/var/www/aurapass.xyz/static/js/
- main.a78dda41.js (416KB) - OLD GOOD VERSION ✅
- main.b65e0522.js (694KB) - NEW VERSION
```

Index.html masih reference main.a78dda41.js, jadi setelah disable Cloudflare, site akan load versi lama yang bagus.
