#!/bin/bash

echo "🔧 Force Create Passport on VPS"
echo "================================"
echo ""

# Get wallet address from user
read -p "Enter your wallet address: " WALLET_ADDRESS

if [ -z "$WALLET_ADDRESS" ]; then
    echo "❌ Wallet address required!"
    exit 1
fi

echo ""
echo "📡 Creating passport for: $WALLET_ADDRESS"
echo ""

# Call API to create passport
curl -X POST "https://www.aurapass.xyz/api/passport/create" \
  -H "Content-Type: application/json" \
  -d "{
    \"user_id\": \"$WALLET_ADDRESS\",
    \"wallet_address\": \"$WALLET_ADDRESS\"
  }" | jq '.'

echo ""
echo ""
echo "✅ Done! Refresh your browser to see the passport."
echo ""
echo "If still not showing, check:"
echo "1. Open browser console (F12)"
echo "2. Go to Network tab"
echo "3. Refresh page"
echo "4. Look for /api/passport/{address} request"
echo "5. Check the response"
