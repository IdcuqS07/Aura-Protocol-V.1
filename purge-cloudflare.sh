#!/bin/bash

# Cloudflare Cache Purge Script
# Usage: ./purge-cloudflare.sh

echo "🔥 Cloudflare Cache Purge Script"
echo "================================"
echo ""

# Check if credentials are set
if [ -z "$CF_ZONE_ID" ] || [ -z "$CF_API_TOKEN" ]; then
    echo "⚠️  Cloudflare credentials not found!"
    echo ""
    echo "Please set environment variables:"
    echo "  export CF_ZONE_ID='your_zone_id'"
    echo "  export CF_API_TOKEN='your_api_token'"
    echo ""
    echo "To get these:"
    echo "1. Login to Cloudflare Dashboard"
    echo "2. Select domain 'aurapass.xyz'"
    echo "3. Zone ID: Found on Overview page (right sidebar)"
    echo "4. API Token: My Profile → API Tokens → Create Token"
    echo "   - Use 'Edit zone DNS' template"
    echo "   - Or create custom with 'Zone.Cache Purge' permission"
    echo ""
    exit 1
fi

echo "Zone ID: ${CF_ZONE_ID:0:8}..."
echo "API Token: ${CF_API_TOKEN:0:8}..."
echo ""

# Purge all cache
echo "🚀 Purging all cache for aurapass.xyz..."
RESPONSE=$(curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/purge_cache" \
     -H "Authorization: Bearer $CF_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{"purge_everything":true}')

# Check response
SUCCESS=$(echo $RESPONSE | grep -o '"success":true')

if [ -n "$SUCCESS" ]; then
    echo "✅ Cache purged successfully!"
    echo ""
    echo "Wait 30 seconds, then test:"
    echo "  https://www.aurapass.xyz/analytics"
    echo ""
else
    echo "❌ Failed to purge cache"
    echo ""
    echo "Response:"
    echo $RESPONSE | python3 -m json.tool 2>/dev/null || echo $RESPONSE
    echo ""
fi
