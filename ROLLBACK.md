# 🔄 ROLLBACK GUIDE

## Cara Rollback Kalau Ada Masalah Fatal

### 1️⃣ Buat Backup Dulu (Sebelum Test)

**Di VPS**:
```bash
cd /root
tar -czf aura-backup-$(date +%Y%m%d-%H%M%S).tar.gz Aura-Protocol-V.1-main/
echo "✅ Backup created"
```

### 2️⃣ Rollback (Kalau Ada Masalah)

**Di VPS**:
```bash
# Stop services
sudo systemctl stop aura-backend

# Lihat backup yang tersedia
ls -lh /root/aura-backup-*.tar.gz

# Restore dari backup terakhir
cd /root
LATEST=$(ls -t aura-backup-*.tar.gz | head -1)
rm -rf Aura-Protocol-V.1-main
tar -xzf $LATEST

# Restart service
sudo systemctl start aura-backend
sudo systemctl status aura-backend

echo "✅ Rollback complete"
```

### 3️⃣ Rollback Frontend (Kalau Perlu)

**Di VPS**:
```bash
# Restore frontend dari backup
cd /var/www
sudo rm -rf aurapass.xyz
sudo tar -xzf /root/frontend-backup-*.tar.gz

# Reload nginx
sudo systemctl reload nginx
```

### 4️⃣ Rollback Database (Kalau Perlu)

**Di VPS**:
```bash
# Backup database dulu
mongodump --db aura_protocol --out /root/mongo-backup-$(date +%Y%m%d-%H%M%S)

# Restore dari backup
LATEST_DB=$(ls -td /root/mongo-backup-* | head -1)
mongorestore --db aura_protocol --drop $LATEST_DB/aura_protocol
```

---

## 🚨 Quick Rollback (1 Command)

**Di VPS**:
```bash
sudo systemctl stop aura-backend && \
cd /root && \
rm -rf Aura-Protocol-V.1-main && \
tar -xzf $(ls -t aura-backup-*.tar.gz | head -1) && \
sudo systemctl start aura-backend && \
echo "✅ Rollback done"
```

---

## 📝 Notes

- Backup dibuat otomatis dengan timestamp
- Rollback hanya restore code, tidak ubah database
- Kalau website masih error, restart nginx: `sudo systemctl restart nginx`
- Kalau masih error, hubungi saya!
