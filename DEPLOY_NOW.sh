#!/bin/bash
# Quick Deploy - Copy paste commands satu per satu

echo "=== STEP 1: Upload ke VPS ==="
echo "Jalankan command ini (masukkan password saat diminta):"
echo ""
echo "scp frontend/build.tar.gz root@103.127.132.132:/tmp/"
echo ""
echo "=== STEP 2: SSH ke VPS ==="
echo "ssh root@103.127.132.132"
echo ""
echo "=== STEP 3: Deploy (jalankan di VPS) ==="
echo "cd /var/www/aurapass.xyz && rm -rf * && tar -xzf /tmp/build.tar.gz && chown -R www-data:www-data /var/www/aurapass.xyz && chmod -R 755 /var/www/aurapass.xyz && nginx -t && systemctl reload nginx"
echo ""
echo "=== STEP 4: Test ==="
echo "https://www.aurapass.xyz"
