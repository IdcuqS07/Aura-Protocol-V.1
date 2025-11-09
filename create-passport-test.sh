#!/bin/bash

# Complete PoH Flow to Create Passport
# Usage: bash create-passport-test.sh

BACKEND="https://www.aurapass.xyz"
WALLET="0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"

echo "🎯 Creating Passport via PoH Flow..."
echo ""

# Step 1: Enroll
echo "1️⃣ Enrolling..."
ENROLL=$(curl -s -X POST "$BACKEND/api/poh/enroll" \
  -H "Content-Type: application/json" \
  -d "{\"user_id\":\"$WALLET\",\"wallet_address\":\"$WALLET\"}")

ENROLLMENT_ID=$(echo "$ENROLL" | jq -r '.enrollment_id')
echo "✅ Enrollment ID: $ENROLLMENT_ID"

# Step 2: Generate Proof
echo ""
echo "2️⃣ Generating proof..."
PROVE=$(curl -s -X POST "$BACKEND/api/poh/prove" \
  -H "Content-Type: application/json" \
  -d "{\"enrollment_id\":\"$ENROLLMENT_ID\",\"identity_secret\":\"$WALLET\"}")

PROOF_HASH=$(echo "$PROVE" | jq -r '.proof_hash')
NULLIFIER=$(echo "$PROVE" | jq -r '.nullifier')
PUBLIC_SIGNALS=$(echo "$PROVE" | jq -c '.public_signals')
echo "✅ Proof generated"

# Step 3: Issue Badge (This should create passport)
echo ""
echo "3️⃣ Issuing badge (creates passport)..."
ISSUE=$(curl -s -X POST "$BACKEND/api/poh/issue" \
  -H "Content-Type: application/json" \
  -d "{\"proof_hash\":\"$PROOF_HASH\",\"nullifier\":\"$NULLIFIER\",\"wallet_address\":\"$WALLET\",\"public_signals\":$PUBLIC_SIGNALS}")

echo "$ISSUE" | jq '.'

# Step 4: Check Passport
echo ""
echo "4️⃣ Checking passport..."
sleep 2
curl -s "$BACKEND/api/passport/$WALLET" | jq '.'

echo ""
echo "✅ Done! Check https://www.aurapass.xyz/passport"
