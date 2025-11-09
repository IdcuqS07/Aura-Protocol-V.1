#!/bin/bash

echo "🧪 AURA PROTOCOL - API ENDPOINT TESTING"
echo "========================================"
echo ""

# Backend URL
BACKEND_URL="http://localhost:9000"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Test counter
PASSED=0
FAILED=0

# Function to test endpoint
test_endpoint() {
    local method=$1
    local endpoint=$2
    local description=$3
    local data=$4
    
    echo -n "Testing: $description ... "
    
    if [ "$method" = "GET" ]; then
        response=$(curl -s -o /dev/null -w "%{http_code}" "$BACKEND_URL$endpoint")
    else
        response=$(curl -s -o /dev/null -w "%{http_code}" -X "$method" \
            -H "Content-Type: application/json" \
            -d "$data" \
            "$BACKEND_URL$endpoint")
    fi
    
    if [ "$response" = "200" ] || [ "$response" = "201" ]; then
        echo -e "${GREEN}✓ PASS${NC} (HTTP $response)"
        ((PASSED++))
    else
        echo -e "${RED}✗ FAIL${NC} (HTTP $response)"
        ((FAILED++))
    fi
}

echo "📋 PHASE 1: PROOF OF HUMANITY"
echo "-------------------------------------------"
# Note: These require OAuth codes, so they will likely fail without real credentials
test_endpoint "POST" "/api/poh/enroll" "PoH Enrollment" '{"user_id":"test_user","wallet_address":"0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"}'
echo ""

echo "📋 PHASE 2: CREDIT PASSPORT"
echo "-------------------------------------------"
test_endpoint "GET" "/api/passport/test_user" "Get Passport (may not exist)" ""
echo ""

echo "📋 PHASE 3: PROOF-AS-A-SERVICE"
echo "-------------------------------------------"
test_endpoint "GET" "/api/v1/health" "Public API Health Check" ""
echo ""

echo "📋 PHASE 4: THE GRAPH"
echo "-------------------------------------------"
# Note: Graph endpoints may not work without deployed subgraph
echo "⏭️  Skipping (requires deployed subgraph)"
echo ""

echo "📋 PHASE 5: AI RISK ORACLE"
echo "-------------------------------------------"
test_endpoint "GET" "/api/oracle/stats" "Oracle Statistics" ""
echo ""

echo "📋 GENERAL ENDPOINTS"
echo "-------------------------------------------"
test_endpoint "GET" "/api/" "Root API" ""
test_endpoint "GET" "/api/analytics" "Analytics Dashboard" ""
test_endpoint "GET" "/api/users" "Get All Users" ""
echo ""

echo "========================================"
echo "📊 TEST SUMMARY"
echo "========================================"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed!${NC}"
else
    echo -e "${YELLOW}⚠️  Some tests failed. This is expected if:${NC}"
    echo "   - Backend is not running"
    echo "   - MongoDB is not connected"
    echo "   - OAuth credentials not configured"
    echo "   - Subgraph not deployed"
fi
echo ""
echo "To start backend: cd backend && uvicorn server:app --reload --port 9000"
echo ""
