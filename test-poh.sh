#!/bin/bash

# Quick PoH Test Script
# Usage: ./test-poh.sh

echo "🧪 Testing Proof of Humanity Flow"
echo "=================================="
echo ""

BACKEND="http://localhost:9000"
WALLET="0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"

# Check backend
echo "📡 Checking backend..."
if curl -s "$BACKEND/api/" > /dev/null; then
    echo "✅ Backend is running"
else
    echo "❌ Backend is not running. Start with: cd backend && uvicorn server:app --reload --port 9000"
    exit 1
fi
echo ""

# Step 1: Enroll
echo "📝 Step 1: Enrollment..."
ENROLL_RESPONSE=$(curl -s -X POST "$BACKEND/api/poh/enroll" \
  -H "Content-Type: application/json" \
  -d "{\"user_id\":\"$WALLET\",\"wallet_address\":\"$WALLET\",\"github_code\":null,\"twitter_code\":null}")

echo "$ENROLL_RESPONSE" | jq '.'

ENROLLMENT_ID=$(echo "$ENROLL_RESPONSE" | jq -r '.enrollment_id')
SCORE=$(echo "$ENROLL_RESPONSE" | jq -r '.score')

if [ "$ENROLLMENT_ID" != "null" ]; then
    echo "✅ Enrollment successful! ID: $ENROLLMENT_ID, Score: $SCORE"
else
    echo "❌ Enrollment failed"
    exit 1
fi
echo ""

# Step 2: Generate Proof
echo "🔐 Step 2: Generate ZK Proof..."
PROVE_RESPONSE=$(curl -s -X POST "$BACKEND/api/poh/prove" \
  -H "Content-Type: application/json" \
  -d "{\"enrollment_id\":\"$ENROLLMENT_ID\",\"identity_secret\":\"$WALLET\"}")

echo "$PROVE_RESPONSE" | jq '.'

PROOF_HASH=$(echo "$PROVE_RESPONSE" | jq -r '.proof_hash')
NULLIFIER=$(echo "$PROVE_RESPONSE" | jq -r '.nullifier')
PUBLIC_SIGNALS=$(echo "$PROVE_RESPONSE" | jq -c '.public_signals')

if [ "$PROOF_HASH" != "null" ]; then
    echo "✅ Proof generated! Hash: ${PROOF_HASH:0:32}..."
else
    echo "❌ Proof generation failed"
    exit 1
fi
echo ""

# Step 3: Issue Badge
echo "🎖️  Step 3: Issue Badge..."
ISSUE_RESPONSE=$(curl -s -X POST "$BACKEND/api/poh/issue" \
  -H "Content-Type: application/json" \
  -d "{\"proof_hash\":\"$PROOF_HASH\",\"nullifier\":\"$NULLIFIER\",\"wallet_address\":\"$WALLET\",\"public_signals\":$PUBLIC_SIGNALS}")

echo "$ISSUE_RESPONSE" | jq '.'

TX_HASH=$(echo "$ISSUE_RESPONSE" | jq -r '.tx_hash')
TOKEN_ID=$(echo "$ISSUE_RESPONSE" | jq -r '.token_id')

if [ "$TX_HASH" != "null" ]; then
    echo "✅ Badge issued! TX: $TX_HASH, Token ID: $TOKEN_ID"
else
    echo "❌ Badge issuance failed"
    exit 1
fi
echo ""

# Step 4: Test Duplicate
echo "🔒 Step 4: Test Duplicate Prevention..."
DUPLICATE_RESPONSE=$(curl -s -X POST "$BACKEND/api/poh/issue" \
  -H "Content-Type: application/json" \
  -d "{\"proof_hash\":\"$PROOF_HASH\",\"nullifier\":\"$NULLIFIER\",\"wallet_address\":\"$WALLET\",\"public_signals\":$PUBLIC_SIGNALS}")

if echo "$DUPLICATE_RESPONSE" | grep -q "already issued"; then
    echo "✅ Duplicate prevention working!"
else
    echo "⚠️  Duplicate was allowed (might be an issue)"
fi
echo ""

echo "🎉 All tests completed!"
echo ""
echo "📊 Summary:"
echo "  Enrollment ID: $ENROLLMENT_ID"
echo "  Score: $SCORE/100"
echo "  Proof Hash: ${PROOF_HASH:0:32}..."
echo "  Nullifier: ${NULLIFIER:0:32}..."
echo "  TX Hash: $TX_HASH"
echo "  Token ID: $TOKEN_ID"
echo ""
echo "✅ Check dashboard: http://localhost:3000/dashboard"
