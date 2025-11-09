#!/bin/bash

# Comprehensive Feature Test Script for Aura Protocol
# Tests all 5 phases of Gelombang 2

API_URL="https://www.aurapass.xyz/api"
TEST_WALLET="0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb"

echo "🧪 AURA PROTOCOL - COMPREHENSIVE FEATURE TEST"
echo "=============================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

pass_count=0
fail_count=0

test_endpoint() {
    local name=$1
    local url=$2
    local method=${3:-GET}
    local data=${4:-}
    
    echo -n "Testing $name... "
    
    if [ "$method" = "POST" ]; then
        response=$(curl -s -w "\n%{http_code}" -X POST "$url" \
            -H "Content-Type: application/json" \
            -d "$data" 2>/dev/null)
    else
        response=$(curl -s -w "\n%{http_code}" "$url" 2>/dev/null)
    fi
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | head -n-1)
    
    if [ "$http_code" = "200" ] || [ "$http_code" = "201" ]; then
        echo -e "${GREEN}✓ PASS${NC} (HTTP $http_code)"
        echo "   Response: $(echo $body | head -c 100)..."
        ((pass_count++))
        return 0
    else
        echo -e "${RED}✗ FAIL${NC} (HTTP $http_code)"
        echo "   Error: $body"
        ((fail_count++))
        return 1
    fi
}

echo "📊 PHASE 0: System Health Check"
echo "--------------------------------"
test_endpoint "Root API" "$API_URL/"
test_endpoint "Analytics Dashboard" "$API_URL/analytics"
echo ""

echo "👤 PHASE 1: User Management"
echo "--------------------------------"
test_endpoint "Get User" "$API_URL/users/$TEST_WALLET"
test_endpoint "Get User Badges" "$API_URL/badges/$TEST_WALLET"
echo ""

echo "🔐 PHASE 2: Proof of Humanity (PoH)"
echo "--------------------------------"
echo -e "${YELLOW}Note: OAuth endpoints require authentication${NC}"
test_endpoint "PoH Callback Endpoint" "$API_URL/poh/callback?code=test123"
echo ""

echo "🎫 PHASE 3: Credit Passport"
echo "--------------------------------"
test_endpoint "Get Passport" "$API_URL/passports/$TEST_WALLET"
test_endpoint "Calculate Credit Score" "$API_URL/passport/score/$TEST_WALLET"
echo ""

echo "🔑 PHASE 4: Proof-as-a-Service API"
echo "--------------------------------"
test_data='{"user_id":"test_user","claim_type":"proof_of_humanity","claim_data":{"score":85}}'
test_endpoint "Generate Proof (No Auth)" "$API_URL/proof/generate" "POST" "$test_data"

test_data='{"proof_hash":"0x123","public_signals":["85","1234567890"]}'
test_endpoint "Verify Proof (No Auth)" "$API_URL/proof/verify" "POST" "$test_data"
echo ""

echo "🤖 PHASE 5: AI Risk Oracle"
echo "--------------------------------"
test_endpoint "Get Risk Score" "$API_URL/oracle/risk-score/$TEST_WALLET"
test_endpoint "Get Lending Recommendation" "$API_URL/oracle/lending-recommendation/$TEST_WALLET"
test_endpoint "Get Risk History" "$API_URL/oracle/risk-history/$TEST_WALLET"
test_endpoint "Get Oracle Stats" "$API_URL/oracle/stats"
echo ""

echo "⛓️  PHASE 6: Blockchain Integration"
echo "--------------------------------"
test_endpoint "Get On-Chain Badges" "$API_URL/blockchain/badges/$TEST_WALLET"
echo ""

echo "=============================================="
echo "📈 TEST SUMMARY"
echo "=============================================="
echo -e "${GREEN}Passed: $pass_count${NC}"
echo -e "${RED}Failed: $fail_count${NC}"
total=$((pass_count + fail_count))
percentage=$((pass_count * 100 / total))
echo "Success Rate: $percentage%"
echo ""

if [ $fail_count -eq 0 ]; then
    echo -e "${GREEN}🎉 ALL TESTS PASSED!${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠️  Some tests failed. Check logs above.${NC}"
    exit 1
fi
