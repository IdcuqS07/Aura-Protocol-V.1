# 📤 Upload Manual ke VPS

File `frontend/build.tar.gz` sudah siap (1.0MB)

## Cara Upload:

### Option 1: Gunakan FileZilla/WinSCP
1. Download FileZilla: https://filezilla-project.org/
2. Connect:
   - Host: `103.127.132.132`
   - Username: `root`
   - Password: (password VPS Anda)
   - Port: `22`
3. Upload `frontend/build.tar.gz` ke `/tmp/`

### Option 2: Gunakan Terminal dengan Password
```bash
cd "/Users/idcuq/Documents/Akindo/Aura Protocol/Aura-Protocol-V.1-main/frontend"
scp build.tar.gz root@103.127.132.132:/tmp/
# Masukkan password saat diminta
```

### Option 3: Setup SSH Key (Recommended)
```bash
# Generate key
ssh-keygen -t rsa -b 4096

# Copy ke VPS
ssh-copy-id root@103.127.132.132

# Upload
scp build.tar.gz root@103.127.132.132:/tmp/
```

## Setelah Upload, SSH ke VPS:

```bash
ssh root@103.127.132.132

# Deploy
cd /var/www/aurapass.xyz
rm -rf *
tar -xzf /tmp/build.tar.gz
chown -R www-data:www-data /var/www/aurapass.xyz
chmod -R 755 /var/www/aurapass.xyz
nginx -t && systemctl reload nginx
exit
```

## Test:
https://www.aurapass.xyz
