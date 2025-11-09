#!/bin/bash

# Detailed Endpoint Testing - One by One
VPS="159.65.134.137"

echo "🔬 DETAILED ENDPOINT TESTING"
echo "============================="
echo ""

test_endpoint() {
    local name=$1
    local method=$2
    local url=$3
    local data=$4
    
    echo "Testing: $name"
    echo "Method: $method"
    echo "URL: $url"
    
    if [ "$method" = "GET" ]; then
        response=$(curl -s -m 10 -w "\nHTTP_CODE:%{http_code}" "$url")
    else
        response=$(curl -s -m 10 -X "$method" -w "\nHTTP_CODE:%{http_code}" \
            -H "Content-Type: application/json" \
            -d "$data" "$url")
    fi
    
    http_code=$(echo "$response" | grep "HTTP_CODE:" | cut -d: -f2)
    body=$(echo "$response" | sed '/HTTP_CODE:/d')
    
    if [ "$http_code" = "200" ] || [ "$http_code" = "201" ]; then
        echo "✅ Status: $http_code"
        echo "Response: $(echo $body | head -c 100)..."
    else
        echo "❌ Status: $http_code"
        echo "Response: $body"
    fi
    echo ""
}

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "PHASE 1: PROOF OF HUMANITY (PoH)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

test_endpoint "1.1 PoH Enroll" "POST" \
    "http://$VPS:9000/api/poh/enroll" \
    '{"user_id":"test_detail_1","wallet_address":"0xDETAIL1"}'

test_endpoint "1.2 PoH Prove" "POST" \
    "http://$VPS:9000/api/poh/prove" \
    '{"enrollment_id":"test-id","identity_secret":"secret123"}'

test_endpoint "1.3 Get Badges" "GET" \
    "http://$VPS:9000/api/badges/demo/0x123" \
    ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "PHASE 2: CREDIT PASSPORT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

test_endpoint "2.1 Create Passport" "POST" \
    "http://$VPS:9000/api/passport/create" \
    '{"user_id":"test_passport","wallet_address":"0xPASSPORT"}'

test_endpoint "2.2 Get Passport Score" "GET" \
    "http://$VPS:9000/api/passport/score/0x123" \
    ""

test_endpoint "2.3 Get Passport by User" "GET" \
    "http://$VPS:9000/api/passport/test_passport" \
    ""

test_endpoint "2.4 Update Passport" "POST" \
    "http://$VPS:9000/api/passport/update" \
    '{"user_id":"test_passport","wallet_address":"0xPASSPORT"}'

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "PHASE 3: PROOF-AS-A-SERVICE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

test_endpoint "3.1 Generate Proof (No API Key)" "POST" \
    "http://$VPS:9000/api/v1/proof/generate" \
    '{"user_id":"test_proof"}'

test_endpoint "3.2 Generate Proof (With Demo Key)" "POST" \
    "http://$VPS:9000/api/v1/proof/generate" \
    '{"user_id":"test_proof"}' \
    "-H 'X-API-Key: demo_key_12345'"

test_endpoint "3.3 Verify Proof" "POST" \
    "http://$VPS:9000/api/v1/proof/verify" \
    '{"proof_hash":"test_hash","nullifier":"test_null"}'

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "PHASE 4: THE GRAPH INTEGRATION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

test_endpoint "4.1 Get Graph Badges" "GET" \
    "http://$VPS:9000/api/graph/badges/0x123" \
    ""

test_endpoint "4.2 Get Graph Stats" "GET" \
    "http://$VPS:9000/api/graph/stats" \
    ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "PHASE 5: AI RISK ORACLE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

test_endpoint "5.1 Get Risk Score" "POST" \
    "http://$VPS:9000/api/oracle/risk-score" \
    '{"wallet_address":"0x123","poh_score":50,"badge_count":3,"onchain_activity":10,"credit_score":500,"account_age_days":30}'

test_endpoint "5.2 Get Lending Recommendation" "POST" \
    "http://$VPS:9000/api/oracle/lending-recommendation" \
    '{"wallet_address":"0x123","loan_amount":1000}'

test_endpoint "5.3 Get Oracle Stats" "GET" \
    "http://$VPS:9000/api/oracle/stats" \
    ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "GENERAL ENDPOINTS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

test_endpoint "6.1 Root API" "GET" \
    "http://$VPS:9000/api/" \
    ""

test_endpoint "6.2 Analytics" "GET" \
    "http://$VPS:9000/api/analytics" \
    ""

test_endpoint "6.3 Users List" "GET" \
    "http://$VPS:9000/api/users" \
    ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ DETAILED TESTING COMPLETE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
