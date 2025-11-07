#!/bin/bash

cd "$(dirname "$0")/contracts"

echo "🚀 Deploying Credit Passport to Polygon Amoy..."
echo ""

# Check .env exists
if [ ! -f .env ]; then
    echo "❌ Error: contracts/.env not found"
    echo "Create .env with PRIVATE_KEY and POLYGON_AMOY_RPC"
    exit 1
fi

# Deploy
npx hardhat run scripts/deploy-credit-passport.js --network amoy

echo ""
echo "✅ Deployment complete!"
echo "Update backend/.env with new contract address"
