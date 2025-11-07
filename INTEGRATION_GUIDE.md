# 🔌 Aura Protocol Integration Guide

Quick start guide for integrating Aura Protocol's Proof-as-a-Service API into your dApp.

---

## 🚀 Quick Start (5 minutes)

### Step 1: Get API Key

1. Visit https://www.aurapass.xyz/api
2. Connect your wallet
3. Click "Generate API Key"
4. Copy your key (starts with `aura_`)

### Step 2: Install Dependencies

**JavaScript/TypeScript:**
```bash
npm install axios
```

**Python:**
```bash
pip install requests
```

### Step 3: Make Your First Request

**JavaScript:**
```javascript
const axios = require('axios');

const API_KEY = 'your_api_key_here';
const BASE_URL = 'https://api.auraprotocol.com';

async function queryPassport(walletAddress) {
  const response = await axios.post(
    `${BASE_URL}/api/v1/passport/query`,
    { wallet_address: walletAddress },
    { headers: { 'X-API-Key': API_KEY } }
  );
  return response.data;
}

// Usage
queryPassport('0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1')
  .then(data => console.log('Credit Score:', data.passport.credit_score));
```

**Python:**
```python
import requests

API_KEY = 'your_api_key_here'
BASE_URL = 'https://api.auraprotocol.com'

def query_passport(wallet_address):
    response = requests.post(
        f'{BASE_URL}/api/v1/passport/query',
        json={'wallet_address': wallet_address},
        headers={'X-API-Key': API_KEY}
    )
    return response.json()

# Usage
data = query_passport('0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1')
print(f"Credit Score: {data['passport']['credit_score']}")
```

---

## 💼 Use Case Examples

### 1. DeFi Lending Protocol

**Scenario**: Check borrower's creditworthiness before approving loan.

```javascript
async function approveLoan(borrowerAddress, loanAmount) {
  // Query credit passport
  const { passport } = await queryPassport(borrowerAddress);
  
  // Decision logic
  if (passport.credit_score >= 750) {
    return {
      approved: true,
      interestRate: 5.0,  // Low rate for good credit
      maxAmount: loanAmount * 2
    };
  } else if (passport.credit_score >= 650) {
    return {
      approved: true,
      interestRate: 8.0,  // Medium rate
      maxAmount: loanAmount
    };
  } else {
    return {
      approved: false,
      reason: 'Credit score too low'
    };
  }
}
```

### 2. NFT Marketplace Reputation

**Scenario**: Display seller reputation badge on NFT listings.

```javascript
async function getSellerReputation(sellerAddress) {
  const { passport } = await queryPassport(sellerAddress);
  
  return {
    badge: passport.grade,  // "Excellent", "Very Good", etc.
    trustScore: passport.credit_score,
    riskLevel: passport.risk_level,
    verified: passport.poh_score > 70
  };
}

// Display in UI
const reputation = await getSellerReputation(seller);
console.log(`Seller Badge: ${reputation.badge} ⭐`);
```

### 3. DAO Voting Weight

**Scenario**: Weight votes based on member reputation.

```javascript
async function calculateVotingPower(memberAddress) {
  const { passport } = await queryPassport(memberAddress);
  
  // Base vote = 1, bonus based on credit score
  const baseVote = 1;
  const bonusMultiplier = passport.credit_score / 1000;
  
  return baseVote * (1 + bonusMultiplier);
}

// Example: 750 credit score = 1.75x voting power
const votingPower = await calculateVotingPower(member);
console.log(`Voting Power: ${votingPower.toFixed(2)}x`);
```

---

## 🔐 Smart Contract Integration

### Solidity Example

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IAuraOracle {
    function getCreditScore(address user) external view returns (uint256);
    function getRiskLevel(address user) external view returns (string memory);
}

contract LendingProtocol {
    IAuraOracle public auraOracle;
    
    constructor(address _oracleAddress) {
        auraOracle = IAuraOracle(_oracleAddress);
    }
    
    function approveLoan(address borrower, uint256 amount) public view returns (bool) {
        uint256 creditScore = auraOracle.getCreditScore(borrower);
        
        if (creditScore >= 750) {
            return true;
        }
        return false;
    }
}
```

---

## 🛡️ Error Handling

### JavaScript

```javascript
async function safeQueryPassport(walletAddress) {
  try {
    const response = await axios.post(
      `${BASE_URL}/api/v1/passport/query`,
      { wallet_address: walletAddress },
      { headers: { 'X-API-Key': API_KEY } }
    );
    return { success: true, data: response.data };
  } catch (error) {
    if (error.response) {
      // API error
      switch (error.response.status) {
        case 403:
          return { success: false, error: 'Invalid API key' };
        case 404:
          return { success: false, error: 'Passport not found' };
        case 429:
          return { success: false, error: 'Rate limit exceeded' };
        default:
          return { success: false, error: 'API error' };
      }
    } else {
      // Network error
      return { success: false, error: 'Network error' };
    }
  }
}
```

### Python

```python
def safe_query_passport(wallet_address):
    try:
        response = requests.post(
            f'{BASE_URL}/api/v1/passport/query',
            json={'wallet_address': wallet_address},
            headers={'X-API-Key': API_KEY},
            timeout=10
        )
        response.raise_for_status()
        return {'success': True, 'data': response.json()}
    except requests.exceptions.HTTPError as e:
        if e.response.status_code == 403:
            return {'success': False, 'error': 'Invalid API key'}
        elif e.response.status_code == 404:
            return {'success': False, 'error': 'Passport not found'}
        elif e.response.status_code == 429:
            return {'success': False, 'error': 'Rate limit exceeded'}
        else:
            return {'success': False, 'error': 'API error'}
    except requests.exceptions.RequestException:
        return {'success': False, 'error': 'Network error'}
```

---

## 📊 Rate Limit Management

### Implement Caching

```javascript
const cache = new Map();
const CACHE_TTL = 5 * 60 * 1000; // 5 minutes

async function cachedQueryPassport(walletAddress) {
  const cached = cache.get(walletAddress);
  
  if (cached && Date.now() - cached.timestamp < CACHE_TTL) {
    return cached.data;
  }
  
  const data = await queryPassport(walletAddress);
  cache.set(walletAddress, { data, timestamp: Date.now() });
  
  return data;
}
```

### Batch Requests

```javascript
async function queryMultiplePassports(addresses) {
  // Process in batches to avoid rate limits
  const batchSize = 10;
  const results = [];
  
  for (let i = 0; i < addresses.length; i += batchSize) {
    const batch = addresses.slice(i, i + batchSize);
    const batchResults = await Promise.all(
      batch.map(addr => queryPassport(addr))
    );
    results.push(...batchResults);
    
    // Wait between batches
    if (i + batchSize < addresses.length) {
      await new Promise(resolve => setTimeout(resolve, 1000));
    }
  }
  
  return results;
}
```

---

## 🧪 Testing

### Test with Demo Keys

```javascript
// Use demo key for testing (100 requests/day)
const DEMO_API_KEY = 'demo_key_12345';

// Test endpoints
async function runTests() {
  console.log('Testing API...');
  
  // Test 1: Health check
  const health = await axios.get(`${BASE_URL}/api/v1/health`);
  console.log('✅ Health check:', health.data.status);
  
  // Test 2: Query passport
  const passport = await queryPassport('0xTest');
  console.log('✅ Passport query:', passport.success);
  
  console.log('All tests passed!');
}
```

---

## 📚 Next Steps

1. **Read API Documentation**: [API_DOCUMENTATION.md](./API_DOCUMENTATION.md)
2. **Check Code Examples**: [CODE_EXAMPLES.md](./CODE_EXAMPLES.md)
3. **Join Discord**: Get help from the community
4. **Upgrade Plan**: Need more requests? Upgrade to Pro or Enterprise

---

## 🆘 Support

- **Documentation**: https://docs.auraprotocol.com
- **Discord**: https://discord.gg/auraprotocol
- **Email**: support@auraprotocol.com
- **GitHub Issues**: https://github.com/IdcuqS07/Aura-Protocol-V.1/issues

---

**Happy Building! 🚀**
