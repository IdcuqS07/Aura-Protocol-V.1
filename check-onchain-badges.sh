#!/bin/bash

# Check On-Chain Badges
# Usage: bash check-onchain-badges.sh <wallet_address>

WALLET="${1:-0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1}"

echo "🔍 Checking On-Chain Badges for: $WALLET"
echo ""

echo "1️⃣ Check via API (database)..."
curl -s "https://www.aurapass.xyz/api/badges/demo/$WALLET" | jq '.badges | length'
echo " badges in database"

echo ""
echo "2️⃣ Check on-chain badges..."
curl -s "https://www.aurapass.xyz/api/blockchain/badges/$WALLET" | jq '.'

echo ""
echo "3️⃣ Check contract directly..."
# SimpleZKBadge contract: 0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678
echo "Contract: 0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678"
echo "Network: Polygon Amoy"
echo "Explorer: https://amoy.polygonscan.com/address/0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678"

echo ""
echo "✅ Check complete!"
