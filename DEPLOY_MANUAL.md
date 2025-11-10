# 🚀 Manual Deployment Guide - Aura Protocol Frontend

## ✅ Build Sudah Selesai!

File `frontend/build.tar.gz` sudah siap untuk di-deploy.

## 📋 Langkah Deployment Manual

### Option 1: Menggunakan SSH Key (Recommended)

```bash
# Upload ke VPS
scp frontend/build.tar.gz root@103.127.132.132:/tmp/

# SSH ke VPS
ssh root@103.127.132.132

# Extract dan deploy
cd /var/www/aurapass.xyz
rm -rf *
tar -xzf /tmp/build.tar.gz
chown -R www-data:www-data /var/www/aurapass.xyz
chmod -R 755 /var/www/aurapass.xyz
rm /tmp/build.tar.gz

# Reload Nginx
nginx -t && systemctl reload nginx

# Exit
exit
```

### Option 2: Menggunakan FTP/SFTP Client

1. Buka FileZilla atau WinSCP
2. Connect ke: `103.127.132.132`
3. Upload `frontend/build.tar.gz` ke `/tmp/`
4. SSH ke VPS dan jalankan:
   ```bash
   cd /var/www/aurapass.xyz
   rm -rf *
   tar -xzf /tmp/build.tar.gz
   chown -R www-data:www-data /var/www/aurapass.xyz
   chmod -R 755 /var/www/aurapass.xyz
   nginx -t && systemctl reload nginx
   ```

### Option 3: Setup SSH Key (Untuk Deployment Otomatis)

```bash
# Generate SSH key (jika belum punya)
ssh-keygen -t rsa -b 4096

# Copy public key ke VPS
ssh-copy-id root@103.127.132.132

# Test connection
ssh root@103.127.132.132

# Setelah setup, jalankan:
bash deploy-frontend.sh
```

## 🌐 Setelah Deploy

Buka browser dan akses:
- **Production**: https://www.aurapass.xyz
- **Test**: https://www.aurapass.xyz/dashboard

## ✅ Checklist

- [x] Build frontend berhasil
- [x] File build.tar.gz sudah dibuat
- [ ] Upload ke VPS
- [ ] Extract di /var/www/aurapass.xyz
- [ ] Set permissions
- [ ] Reload Nginx
- [ ] Test di browser

## 🔧 Troubleshooting

### Jika Nginx error:
```bash
nginx -t
systemctl status nginx
tail -f /var/log/nginx/error.log
```

### Jika permission denied:
```bash
chown -R www-data:www-data /var/www/aurapass.xyz
chmod -R 755 /var/www/aurapass.xyz
```

### Jika 404 error:
```bash
ls -la /var/www/aurapass.xyz
# Pastikan ada file index.html
```

## 📞 Support

Jika ada masalah, cek:
1. SSH connection ke VPS
2. Nginx configuration
3. File permissions
4. Browser cache (Ctrl+Shift+R)
