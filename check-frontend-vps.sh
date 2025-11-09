#!/bin/bash

echo "🔍 Checking Frontend Structure on VPS..."
echo ""

ssh root@159.65.134.137 << 'ENDSSH'

echo "1️⃣ Check /var/www structure..."
ls -la /var/www/

echo ""
echo "2️⃣ Check if frontend repo exists..."
ls -la /var/www/ | grep -i aura

echo ""
echo "3️⃣ Check Nginx config for frontend..."
cat /etc/nginx/sites-available/aurapass.xyz | grep -A 3 "location /"

echo ""
echo "4️⃣ Find where frontend is served from..."
cat /etc/nginx/sites-available/aurapass.xyz | grep "root"

ENDSSH

echo ""
echo "✅ Check complete!"
