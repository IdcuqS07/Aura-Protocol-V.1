#!/bin/bash
echo "🔧 Bypass Cloudflare Cache - Direct to VPS"
echo ""
echo "Menambahkan entry ke /etc/hosts..."
echo "159.65.134.137 www.aurapass.xyz" | sudo tee -a /etc/hosts
echo ""
echo "Flushing DNS cache..."
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
echo ""
echo "✅ Done! Sekarang www.aurapass.xyz akan langsung ke VPS (bypass Cloudflare)"
echo ""
echo "Test: curl -s http://www.aurapass.xyz/ | grep -o 'main\.[a-z0-9]*\.js'"
echo ""
echo "Untuk restore (kembali ke Cloudflare):"
echo "sudo sed -i '' '/159.65.134.137 www.aurapass.xyz/d' /etc/hosts"
