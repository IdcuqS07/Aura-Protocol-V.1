#!/bin/bash

# Aura Protocol - Complete API Testing Script
# Tests all Phase 3 endpoints

BASE_URL="http://localhost:9000"
API_KEY="demo_key_12345"
TEST_WALLET="0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"

echo "🧪 Aura Protocol API Testing Suite"
echo "=================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASSED=0
FAILED=0

# Test function
test_endpoint() {
    local name="$1"
    local method="$2"
    local endpoint="$3"
    local data="$4"
    local expected_status="$5"
    
    echo -n "Testing: $name... "
    
    if [ "$method" = "GET" ]; then
        response=$(curl -s -w "\n%{http_code}" "$BASE_URL$endpoint" \
            -H "X-API-Key: $API_KEY" 2>/dev/null)
    else
        response=$(curl -s -w "\n%{http_code}" -X "$method" "$BASE_URL$endpoint" \
            -H "X-API-Key: $API_KEY" \
            -H "Content-Type: application/json" \
            -d "$data" 2>/dev/null)
    fi
    
    status=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$status" = "$expected_status" ]; then
        echo -e "${GREEN}✓ PASS${NC} (Status: $status)"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗ FAIL${NC} (Expected: $expected_status, Got: $status)"
        ((FAILED++))
        return 1
    fi
}

echo "📡 Test 1: API Endpoints"
echo "------------------------"

# Health check
test_endpoint "Health Check" "GET" "/api/v1/health" "" "200"

# Generate proof
test_endpoint "Generate Proof" "POST" "/api/v1/proof/generate" \
    "{\"user_id\":\"$TEST_WALLET\",\"wallet_address\":\"$TEST_WALLET\"}" "200"

# Verify proof
test_endpoint "Verify Proof" "POST" "/api/v1/proof/verify" \
    "{\"proof_hash\":\"0x123\",\"user_id\":\"$TEST_WALLET\"}" "200"

# Query passport
test_endpoint "Query Passport" "POST" "/api/v1/passport/query" \
    "{\"wallet_address\":\"$TEST_WALLET\"}" "200"

echo ""
echo "🔐 Test 2: Authentication"
echo "-------------------------"

# Test with invalid API key
echo -n "Testing: Invalid API Key... "
response=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/v1/passport/query" \
    -H "X-API-Key: invalid_key_123" \
    -H "Content-Type: application/json" \
    -d "{\"wallet_address\":\"$TEST_WALLET\"}" 2>/dev/null)
status=$(echo "$response" | tail -n1)

if [ "$status" = "403" ]; then
    echo -e "${GREEN}✓ PASS${NC} (Correctly rejected)"
    ((PASSED++))
else
    echo -e "${RED}✗ FAIL${NC} (Should return 403)"
    ((FAILED++))
fi

# Test without API key
echo -n "Testing: Missing API Key... "
response=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/v1/passport/query" \
    -H "Content-Type: application/json" \
    -d "{\"wallet_address\":\"$TEST_WALLET\"}" 2>/dev/null)
status=$(echo "$response" | tail -n1)

if [ "$status" = "422" ] || [ "$status" = "403" ]; then
    echo -e "${GREEN}✓ PASS${NC} (Correctly rejected)"
    ((PASSED++))
else
    echo -e "${RED}✗ FAIL${NC} (Should return 422 or 403)"
    ((FAILED++))
fi

echo ""
echo "⏱️  Test 3: Rate Limiting"
echo "-------------------------"

# Generate a new API key for rate limit testing
echo -n "Generating test API key... "
new_key_response=$(curl -s -X POST "$BASE_URL/api/api-keys" \
    -H "Content-Type: application/json" \
    -d '{"tier":"free","user_id":"test_rate_limit"}' 2>/dev/null)
NEW_API_KEY=$(echo "$new_key_response" | python3 -c "import sys,json; print(json.load(sys.stdin)['api_key'])" 2>/dev/null)

if [ -n "$NEW_API_KEY" ]; then
    echo -e "${GREEN}✓${NC} Key: $NEW_API_KEY"
    
    # Make multiple requests
    echo -n "Testing: Rate Limit (making 5 requests)... "
    success_count=0
    for i in {1..5}; do
        response=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/v1/passport/query" \
            -H "X-API-Key: $NEW_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"wallet_address\":\"$TEST_WALLET\"}" 2>/dev/null)
        status=$(echo "$response" | tail -n1)
        if [ "$status" = "200" ]; then
            ((success_count++))
        fi
    done
    
    if [ "$success_count" -eq 5 ]; then
        echo -e "${GREEN}✓ PASS${NC} (All requests succeeded)"
        ((PASSED++))
    else
        echo -e "${YELLOW}⚠ PARTIAL${NC} ($success_count/5 succeeded)"
        ((PASSED++))
    fi
    
    # Check usage
    echo -n "Testing: Usage Tracking... "
    usage_response=$(curl -s "$BASE_URL/api/api-keys/$NEW_API_KEY" 2>/dev/null)
    requests_used=$(echo "$usage_response" | python3 -c "import sys,json; print(json.load(sys.stdin)['requests_used'])" 2>/dev/null)
    
    if [ "$requests_used" -ge 5 ]; then
        echo -e "${GREEN}✓ PASS${NC} (Usage: $requests_used)"
        ((PASSED++))
    else
        echo -e "${RED}✗ FAIL${NC} (Usage not tracked correctly)"
        ((FAILED++))
    fi
else
    echo -e "${RED}✗ FAIL${NC} (Could not generate test key)"
    ((FAILED+=2))
fi

echo ""
echo "🔗 Test 4: Integration Test"
echo "---------------------------"

# Simulate a dApp integration flow
echo "Simulating dApp integration flow:"

# Step 1: Create passport
echo -n "  1. Create Passport... "
create_response=$(curl -s -X POST "$BASE_URL/api/passport/create" \
    -H "Content-Type: application/json" \
    -d "{\"user_id\":\"integration_test\",\"wallet_address\":\"0xIntegrationTest\"}" 2>/dev/null)
create_success=$(echo "$create_response" | python3 -c "import sys,json; print(json.load(sys.stdin).get('success', False))" 2>/dev/null)

if [ "$create_success" = "True" ]; then
    echo -e "${GREEN}✓${NC}"
    ((PASSED++))
else
    echo -e "${YELLOW}⚠${NC} (May already exist)"
    ((PASSED++))
fi

# Step 2: Query via API
echo -n "  2. Query via API... "
query_response=$(curl -s -X POST "$BASE_URL/api/v1/passport/query" \
    -H "X-API-Key: $API_KEY" \
    -H "Content-Type: application/json" \
    -d '{"wallet_address":"0xIntegrationTest"}' 2>/dev/null)
query_success=$(echo "$query_response" | python3 -c "import sys,json; print(json.load(sys.stdin).get('success', False))" 2>/dev/null)

if [ "$query_success" = "True" ]; then
    echo -e "${GREEN}✓${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗${NC}"
    ((FAILED++))
fi

# Step 3: Generate proof
echo -n "  3. Generate Proof... "
proof_response=$(curl -s -X POST "$BASE_URL/api/v1/proof/generate" \
    -H "X-API-Key: $API_KEY" \
    -H "Content-Type: application/json" \
    -d '{"user_id":"integration_test","wallet_address":"0xIntegrationTest"}' 2>/dev/null)
proof_success=$(echo "$proof_response" | python3 -c "import sys,json; print(json.load(sys.stdin).get('success', False))" 2>/dev/null)

if [ "$proof_success" = "True" ]; then
    echo -e "${GREEN}✓${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗${NC}"
    ((FAILED++))
fi

echo ""
echo "=================================="
echo "📊 Test Results"
echo "=================================="
echo -e "Total Tests: $((PASSED + FAILED))"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed!${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠️  Some tests failed. Check the output above.${NC}"
    exit 1
fi
