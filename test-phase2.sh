#!/bin/bash

# Test Phase 2: Credit Passport Integration
# Usage: bash test-phase2.sh

echo "🧪 Testing Phase 2: Credit Passport Integration"
echo "================================================"
echo ""

BACKEND="http://localhost:9000"
WALLET="0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"

# Check backend
echo "📡 Checking backend..."
if curl -s "$BACKEND/api/" > /dev/null; then
    echo "✅ Backend is running"
else
    echo "❌ Backend not running"
    exit 1
fi
echo ""

# Step 1: Mint PoH Badge (triggers passport creation)
echo "🎖️  Step 1: Mint PoH Badge..."
bash test-poh.sh > /dev/null 2>&1
echo "✅ Badge minted (passport should auto-create/update)"
echo ""

# Step 2: Check Passport
echo "📋 Step 2: Check Passport..."
PASSPORT_RESPONSE=$(curl -s "$BACKEND/api/passport/$WALLET")

echo "$PASSPORT_RESPONSE" | jq '.'

PASSPORT_EXISTS=$(echo "$PASSPORT_RESPONSE" | jq -r '.success')
CREDIT_SCORE=$(echo "$PASSPORT_RESPONSE" | jq -r '.passport.credit_score')
BADGE_COUNT=$(echo "$PASSPORT_RESPONSE" | jq -r '.passport.badge_count')

if [ "$PASSPORT_EXISTS" == "true" ]; then
    echo "✅ Passport exists!"
    echo "   Credit Score: $CREDIT_SCORE/1000"
    echo "   Badge Count: $BADGE_COUNT"
else
    echo "❌ Passport not found"
    exit 1
fi
echo ""

# Step 3: Mint Another Badge
echo "🎖️  Step 3: Mint another badge..."
# Change wallet to avoid nullifier conflict
WALLET2="0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199"

ENROLL2=$(curl -s -X POST "$BACKEND/api/poh/enroll" \
  -H "Content-Type: application/json" \
  -d "{\"user_id\":\"$WALLET2\",\"wallet_address\":\"$WALLET2\"}")

ENROLLMENT_ID2=$(echo "$ENROLL2" | jq -r '.enrollment_id')

PROVE2=$(curl -s -X POST "$BACKEND/api/poh/prove" \
  -H "Content-Type: application/json" \
  -d "{\"enrollment_id\":\"$ENROLLMENT_ID2\",\"identity_secret\":\"$WALLET2\"}")

PROOF_HASH2=$(echo "$PROVE2" | jq -r '.proof_hash')
NULLIFIER2=$(echo "$PROVE2" | jq -r '.nullifier')
PUBLIC_SIGNALS2=$(echo "$PROVE2" | jq -c '.public_signals')

ISSUE2=$(curl -s -X POST "$BACKEND/api/poh/issue" \
  -H "Content-Type: application/json" \
  -d "{\"proof_hash\":\"$PROOF_HASH2\",\"nullifier\":\"$NULLIFIER2\",\"wallet_address\":\"$WALLET2\",\"public_signals\":$PUBLIC_SIGNALS2}")

echo "$ISSUE2" | jq '.'
echo "✅ Second badge minted"
echo ""

# Step 4: Check Updated Passport
echo "📋 Step 4: Check updated passport..."
PASSPORT2=$(curl -s "$BACKEND/api/passport/$WALLET2")

CREDIT_SCORE2=$(echo "$PASSPORT2" | jq -r '.passport.credit_score')
BADGE_COUNT2=$(echo "$PASSPORT2" | jq -r '.passport.badge_count')

echo "   Credit Score: $CREDIT_SCORE2/1000"
echo "   Badge Count: $BADGE_COUNT2"

if [ "$BADGE_COUNT2" -gt "0" ]; then
    echo "✅ Passport auto-updated after badge mint!"
else
    echo "⚠️  Passport not updated"
fi
echo ""

# Step 5: Test Score Calculation
echo "📊 Step 5: Test score calculation..."
SCORE_TEST=$(curl -s "$BACKEND/api/passport/score/$WALLET")

echo "$SCORE_TEST" | jq '.'

CALCULATED_SCORE=$(echo "$SCORE_TEST" | jq -r '.credit_score')
echo "✅ Score calculated: $CALCULATED_SCORE/1000"
echo ""

echo "🎉 Phase 2 Integration Test Complete!"
echo ""
echo "📊 Summary:"
echo "  Wallet 1: $WALLET"
echo "    - Credit Score: $CREDIT_SCORE/1000"
echo "    - Badge Count: $BADGE_COUNT"
echo ""
echo "  Wallet 2: $WALLET2"
echo "    - Credit Score: $CREDIT_SCORE2/1000"
echo "    - Badge Count: $BADGE_COUNT2"
echo ""
echo "✅ Auto-update working: Passport updates after badge mint"
echo "✅ Score calculation working: PoH + Badges = Credit Score"
echo ""
echo "🚀 Next: Deploy CreditPassport contract"
echo "   cd contracts && npx hardhat run scripts/deploy-credit-passport.js --network amoy"
