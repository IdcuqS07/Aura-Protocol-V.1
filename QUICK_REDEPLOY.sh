#!/bin/bash
set -e

echo "🔨 Building frontend..."
cd frontend
yarn build

echo "📦 Creating tarball..."
tar czf build.tar.gz build/

echo "📤 Uploading to VPS..."
scp build.tar.gz root@103.127.132.132:/tmp/

echo "🚀 Deploying on VPS..."
ssh root@103.127.132.132 << 'EOF'
cd /var/www/aurapass.xyz
rm -rf *
tar xzf /tmp/build.tar.gz
mv build/* .
rmdir build
chown -R www-data:www-data /var/www/aurapass.xyz
chmod -R 755 /var/www/aurapass.xyz
systemctl reload nginx
echo "✅ Deployment complete!"
EOF

echo "✅ Done! Visit https://www.aurapass.xyz"
