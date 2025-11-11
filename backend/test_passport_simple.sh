#!/bin/bash

# Test Credit Passport Routes
# Usage: ./test_passport_simple.sh [base_url]

BASE_URL="${1:-http://localhost:9000}"
WALLET="0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"

echo "Testing Credit Passport Routes"
echo "Base URL: $BASE_URL"
echo "Wallet: $WALLET"
echo ""

# Test 1: Calculate Score
echo "=== Test 1: Calculate Score ==="
curl -X POST "$BASE_URL/api/passport/calculate-score" \
  -H "Content-Type: application/json" \
  -d "{\"wallet_address\": \"$WALLET\"}" \
  2>/dev/null | python3 -m json.tool
echo ""

# Test 2: Get Passport (will fail if not minted yet)
echo "=== Test 2: Get Passport ==="
curl -X GET "$BASE_URL/api/passport/$WALLET" \
  2>/dev/null | python3 -m json.tool
echo ""

echo "✅ Tests complete!"
