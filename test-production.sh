#!/bin/bash

# Aura Protocol - Production Testing Script
# Tests all API endpoints and features

set -e

echo "🧪 Aura Protocol - Production Testing"
echo "======================================"
echo ""

BACKEND_URL="http://159.65.134.137:9000"
FRONTEND_URL="https://www.aurapass.xyz"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

test_endpoint() {
    local name=$1
    local url=$2
    local method=${3:-GET}
    
    echo -n "Testing ${name}... "
    
    if [ "$method" = "GET" ]; then
        response=$(curl -s -o /dev/null -w "%{http_code}" "${url}")
    else
        response=$(curl -s -o /dev/null -w "%{http_code}" -X POST "${url}" -H "Content-Type: application/json" -d '{}')
    fi
    
    if [ "$response" = "200" ] || [ "$response" = "422" ] || [ "$response" = "400" ]; then
        echo -e "${GREEN}✅ OK (${response})${NC}"
        return 0
    else
        echo -e "${RED}❌ FAIL (${response})${NC}"
        return 1
    fi
}

echo -e "${BLUE}📡 Testing Backend Endpoints${NC}"
echo ""

# Core API
test_endpoint "Root API" "${BACKEND_URL}/api/"
test_endpoint "Analytics" "${BACKEND_URL}/api/analytics"
test_endpoint "Users List" "${BACKEND_URL}/api/users"

# PoH Endpoints
echo ""
echo -e "${BLUE}🔐 Testing PoH Endpoints${NC}"
test_endpoint "PoH Enroll" "${BACKEND_URL}/api/poh/enroll" "POST"

# Passport Endpoints
echo ""
echo -e "${BLUE}🎫 Testing Passport Endpoints${NC}"
test_endpoint "Passport Score" "${BACKEND_URL}/api/passport/score/0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"

# Oracle Endpoints
echo ""
echo -e "${BLUE}🤖 Testing AI Oracle Endpoints${NC}"
test_endpoint "Risk Score" "${BACKEND_URL}/api/oracle/risk-score" "POST"
test_endpoint "Oracle Stats" "${BACKEND_URL}/api/oracle/stats"

# Badge Endpoints
echo ""
echo -e "${BLUE}🏅 Testing Badge Endpoints${NC}"
test_endpoint "Demo Badges" "${BACKEND_URL}/api/badges/demo/0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"

# Frontend Check
echo ""
echo -e "${BLUE}🌐 Testing Frontend${NC}"
echo -n "Testing Frontend... "
frontend_response=$(curl -s -o /dev/null -w "%{http_code}" "${FRONTEND_URL}")
if [ "$frontend_response" = "200" ]; then
    echo -e "${GREEN}✅ OK${NC}"
else
    echo -e "${RED}❌ FAIL (${frontend_response})${NC}"
fi

echo ""
echo -e "${GREEN}✅ Testing Complete!${NC}"
echo ""
echo "📊 Summary:"
echo "  Backend:  ${BACKEND_URL}"
echo "  Frontend: ${FRONTEND_URL}"
echo ""
echo "🔗 Quick Links:"
echo "  Dashboard:      ${FRONTEND_URL}/dashboard"
echo "  PoH:            ${FRONTEND_URL}/verify"
echo "  Credit Passport: ${FRONTEND_URL}/passport"
echo "  Risk Oracle:    ${FRONTEND_URL}/oracle"
echo "  Analytics:      ${FRONTEND_URL}/analytics"
echo ""
