#!/bin/bash

# Check Passport via API
# Usage: bash check-passport-api.sh <wallet_address>

WALLET="${1:-0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1}"

echo "🔍 Checking Passport for: $WALLET"
echo ""

echo "1️⃣ Check passport via API..."
curl -s "https://www.aurapass.xyz/api/passport/$WALLET" | jq '.'

echo ""
echo "2️⃣ Check badges..."
curl -s "https://www.aurapass.xyz/api/badges/demo/$WALLET" | jq '.'

echo ""
echo "3️⃣ Calculate score..."
curl -s "https://www.aurapass.xyz/api/passport/score/$WALLET" | jq '.'

echo ""
echo "✅ Check complete!"
