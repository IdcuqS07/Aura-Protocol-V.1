#!/bin/bash

echo "🔍 Checking Backend-Frontend Deployment Sync"
echo "=============================================="
echo ""

# Check backend routes
echo "📡 Backend Routes Check:"
echo "------------------------"
echo ""

echo "1. Checking PoH routes..."
grep -q "from poh_routes import router as poh_router" backend/server.py && echo "   ✅ PoH routes imported" || echo "   ❌ PoH routes NOT imported"

echo "2. Checking Passport routes..."
grep -q "from passport_routes import router as passport_router" backend/server.py && echo "   ✅ Passport routes imported" || echo "   ❌ Passport routes NOT imported"

echo "3. Checking Oracle routes..."
grep -q "from oracle_routes import router as oracle_router" backend/server.py && echo "   ✅ Oracle routes imported" || echo "   ❌ Oracle routes NOT imported"

echo "4. Checking Proof routes..."
grep -q "from proof_routes import router as proof_router" backend/server.py && echo "   ✅ Proof routes imported" || echo "   ❌ Proof routes NOT imported"

echo ""
echo "📦 Frontend Contract Addresses:"
echo "-------------------------------"
echo ""

echo "1. Badge Contract in badgeMinting.js:"
grep "BADGE_CONTRACT_ADDRESS" frontend/src/utils/badgeMinting.js | head -1

echo ""
echo "2. Passport Contract in passportContract.js:"
grep "CONTRACT_ADDRESS" frontend/src/utils/passportContract.js | head -1

echo ""
echo "📋 Expected Contract Addresses:"
echo "-------------------------------"
echo "SimpleZKBadge (V2): 0x3d586E681b12B07825F17Ce19B28e1F576a1aF89"
echo "CreditPassport:     0x1112373c9954B9bbFd91eb21175699b609A1b551"
echo "ProofRegistry:      0x296DB144E62C8C826bffA4503Dc9Fbf29F25D44B"
echo ""

echo "🔗 Backend API Endpoints:"
echo "-------------------------"
echo ""
echo "Expected endpoints:"
echo "  ✅ POST /api/poh/enroll"
echo "  ✅ POST /api/poh/generate-proof"
echo "  ✅ POST /api/poh/issue-badge"
echo "  ✅ GET  /api/passport/{user_id}"
echo "  ✅ POST /api/passport/create"
echo "  ✅ POST /api/oracle/risk-score"
echo "  ✅ POST /api/proof/generate"
echo "  ✅ POST /api/proof/verify"
echo ""

echo "🌐 Frontend Pages:"
echo "------------------"
echo ""
ls -1 frontend/src/components/*.js | grep -E "(ProofOfHumanity|CreditPassport|VerifyIdentity)" | while read file; do
    basename "$file" | sed 's/\.js$//' | sed 's/^/  ✅ /'
done
echo ""

echo "📊 Deployment Status:"
echo "---------------------"
echo ""
echo "Backend:"
echo "  Location: /var/www/aura-backend-new"
echo "  Status: Check with 'ssh root@103.127.132.132 pm2 status'"
echo ""
echo "Frontend:"
echo "  Build: frontend/build.tar.gz"
echo "  Status: Ready to deploy"
echo "  Target: /var/www/aurapass.xyz"
echo ""

echo "🔍 Contract Address Sync Check:"
echo "--------------------------------"
echo ""

# Check if frontend uses correct addresses
BADGE_ADDR=$(grep "BADGE_CONTRACT_ADDRESS" frontend/src/utils/badgeMinting.js | grep -o "0x[a-fA-F0-9]*" | head -1)
PASSPORT_ADDR=$(grep "CONTRACT_ADDRESS" frontend/src/utils/passportContract.js | grep -o "0x[a-fA-F0-9]*" | head -1)

echo "Frontend Badge Address:    $BADGE_ADDR"
echo "Expected Badge Address:    0x3d586E681b12B07825F17Ce19B28e1F576a1aF89"
if [ "$BADGE_ADDR" = "0x3d586E681b12B07825F17Ce19B28e1F576a1aF89" ]; then
    echo "  ✅ MATCH"
else
    echo "  ⚠️  MISMATCH - Frontend needs update!"
fi

echo ""
echo "Frontend Passport Address: $PASSPORT_ADDR"
echo "Expected Passport Address: 0x1112373c9954B9bbFd91eb21175699b609A1b551"
if [ "$PASSPORT_ADDR" = "0x1112373c9954B9bbFd91eb21175699b609A1b551" ]; then
    echo "  ✅ MATCH"
else
    echo "  ⚠️  MISMATCH - Frontend needs update!"
fi

echo ""
echo "✅ Sync Check Complete!"
echo ""
echo "Next Steps:"
echo "1. If backend routes OK: Backend is ready ✅"
echo "2. If contract addresses match: Frontend is ready ✅"
echo "3. Deploy frontend: Run commands in DEPLOY_MANUAL.txt"
