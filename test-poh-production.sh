#!/bin/bash

echo "🧪 Testing PoH on Production"
echo "============================="
echo ""

BACKEND="https://www.aurapass.xyz"
WALLET="0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"

echo "1️⃣ Test backend API..."
curl -s "$BACKEND/api/" | jq '.'

echo ""
echo "2️⃣ Test PoH enrollment..."
curl -s -X POST "$BACKEND/api/poh/enroll" \
  -H "Content-Type: application/json" \
  -d "{\"user_id\":\"$WALLET\",\"wallet_address\":\"$WALLET\"}" \
  | jq '.'

echo ""
echo "✅ If you see enrollment_id above, PoH is WORKING!"
echo ""
echo "📝 Next: Go to https://www.aurapass.xyz/poh and test full flow"
