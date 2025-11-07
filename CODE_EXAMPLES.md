# 💻 Aura Protocol - Code Examples

Complete code examples in JavaScript, Python, and Solidity.

---

## 📦 JavaScript/TypeScript Examples

### Basic Setup

```javascript
// config.js
module.exports = {
  API_KEY: process.env.AURA_API_KEY,
  BASE_URL: 'https://api.auraprotocol.com',
  TIMEOUT: 10000
};
```

### 1. Generate ZK Proof

```javascript
const axios = require('axios');
const { API_KEY, BASE_URL } = require('./config');

async function generateProof(userId, walletAddress) {
  try {
    const response = await axios.post(
      `${BASE_URL}/api/v1/proof/generate`,
      {
        user_id: userId,
        wallet_address: walletAddress
      },
      {
        headers: {
          'X-API-Key': API_KEY,
          'Content-Type': 'application/json'
        }
      }
    );
    
    return {
      success: true,
      proofHash: response.data.proof.proof_hash,
      metadata: response.data.proof.metadata
    };
  } catch (error) {
    return {
      success: false,
      error: error.response?.data?.detail || error.message
    };
  }
}

// Usage
generateProof('0x123...', '0x123...').then(console.log);
```

### 2. Verify Proof

```javascript
async function verifyProof(proofHash, userId) {
  try {
    const response = await axios.post(
      `${BASE_URL}/api/v1/proof/verify`,
      {
        proof_hash: proofHash,
        user_id: userId
      },
      {
        headers: {
          'X-API-Key': API_KEY,
          'Content-Type': 'application/json'
        }
      }
    );
    
    return {
      success: true,
      isValid: response.data.is_valid,
      verifiedAt: response.data.verified_at
    };
  } catch (error) {
    return {
      success: false,
      error: error.response?.data?.detail || error.message
    };
  }
}
```

### 3. Query Passport with Retry Logic

```javascript
async function queryPassportWithRetry(walletAddress, maxRetries = 3) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      const response = await axios.post(
        `${BASE_URL}/api/v1/passport/query`,
        { wallet_address: walletAddress },
        {
          headers: { 'X-API-Key': API_KEY },
          timeout: 10000
        }
      );
      
      return {
        success: true,
        passport: response.data.passport
      };
    } catch (error) {
      if (i === maxRetries - 1) {
        return {
          success: false,
          error: error.response?.data?.detail || error.message
        };
      }
      // Wait before retry (exponential backoff)
      await new Promise(resolve => setTimeout(resolve, 1000 * Math.pow(2, i)));
    }
  }
}
```

### 4. React Hook

```typescript
// useAuraPassport.ts
import { useState, useEffect } from 'react';
import axios from 'axios';

interface Passport {
  passport_id: string;
  credit_score: number;
  grade: string;
  risk_level: string;
}

export function useAuraPassport(walletAddress: string | null) {
  const [passport, setPassport] = useState<Passport | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!walletAddress) return;

    const fetchPassport = async () => {
      setLoading(true);
      setError(null);

      try {
        const response = await axios.post(
          `${process.env.REACT_APP_AURA_API_URL}/api/v1/passport/query`,
          { wallet_address: walletAddress },
          {
            headers: {
              'X-API-Key': process.env.REACT_APP_AURA_API_KEY!
            }
          }
        );

        setPassport(response.data.passport);
      } catch (err: any) {
        setError(err.response?.data?.detail || 'Failed to fetch passport');
      } finally {
        setLoading(false);
      }
    };

    fetchPassport();
  }, [walletAddress]);

  return { passport, loading, error };
}

// Usage in component
function UserProfile({ address }: { address: string }) {
  const { passport, loading, error } = useAuraPassport(address);

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;
  if (!passport) return <div>No passport found</div>;

  return (
    <div>
      <h2>Credit Score: {passport.credit_score}</h2>
      <p>Grade: {passport.grade}</p>
      <p>Risk: {passport.risk_level}</p>
    </div>
  );
}
```

---

## 🐍 Python Examples

### Basic Setup

```python
# config.py
import os
from dotenv import load_dotenv

load_dotenv()

API_KEY = os.getenv('AURA_API_KEY')
BASE_URL = 'https://api.auraprotocol.com'
TIMEOUT = 10
```

### 1. Generate Proof

```python
import requests
from config import API_KEY, BASE_URL, TIMEOUT

def generate_proof(user_id: str, wallet_address: str) -> dict:
    """Generate ZK proof for user"""
    try:
        response = requests.post(
            f'{BASE_URL}/api/v1/proof/generate',
            json={
                'user_id': user_id,
                'wallet_address': wallet_address
            },
            headers={'X-API-Key': API_KEY},
            timeout=TIMEOUT
        )
        response.raise_for_status()
        
        data = response.json()
        return {
            'success': True,
            'proof_hash': data['proof']['proof_hash'],
            'metadata': data['proof']['metadata']
        }
    except requests.exceptions.RequestException as e:
        return {
            'success': False,
            'error': str(e)
        }

# Usage
result = generate_proof('0x123...', '0x123...')
print(result)
```

### 2. Async Python with aiohttp

```python
import aiohttp
import asyncio
from typing import List, Dict

async def query_passport_async(
    session: aiohttp.ClientSession,
    wallet_address: str
) -> Dict:
    """Async passport query"""
    try:
        async with session.post(
            f'{BASE_URL}/api/v1/passport/query',
            json={'wallet_address': wallet_address},
            headers={'X-API-Key': API_KEY}
        ) as response:
            data = await response.json()
            return {
                'success': True,
                'address': wallet_address,
                'passport': data['passport']
            }
    except Exception as e:
        return {
            'success': False,
            'address': wallet_address,
            'error': str(e)
        }

async def query_multiple_passports(addresses: List[str]) -> List[Dict]:
    """Query multiple passports concurrently"""
    async with aiohttp.ClientSession() as session:
        tasks = [
            query_passport_async(session, addr)
            for addr in addresses
        ]
        return await asyncio.gather(*tasks)

# Usage
addresses = ['0x123...', '0x456...', '0x789...']
results = asyncio.run(query_multiple_passports(addresses))
for result in results:
    if result['success']:
        print(f"{result['address']}: {result['passport']['credit_score']}")
```

### 3. Flask API Wrapper

```python
from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

@app.route('/check-credit', methods=['POST'])
def check_credit():
    """Endpoint to check user credit score"""
    data = request.json
    wallet_address = data.get('wallet_address')
    
    if not wallet_address:
        return jsonify({'error': 'wallet_address required'}), 400
    
    # Query Aura API
    response = requests.post(
        f'{BASE_URL}/api/v1/passport/query',
        json={'wallet_address': wallet_address},
        headers={'X-API-Key': API_KEY}
    )
    
    if response.status_code == 200:
        passport = response.json()['passport']
        return jsonify({
            'credit_score': passport['credit_score'],
            'grade': passport['grade'],
            'risk_level': passport['risk_level']
        })
    else:
        return jsonify({'error': 'Failed to fetch passport'}), response.status_code

if __name__ == '__main__':
    app.run(debug=True)
```

---

## ⛓️ Solidity Examples

### 1. Oracle Interface

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IAuraOracle {
    function getCreditScore(address user) external view returns (uint256);
    function getPassportId(address user) external view returns (string memory);
    function getRiskLevel(address user) external view returns (uint8);
    function isVerified(address user) external view returns (bool);
}
```

### 2. Lending Protocol Integration

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./IAuraOracle.sol";

contract AuraLendingProtocol {
    IAuraOracle public auraOracle;
    
    uint256 public constant MIN_CREDIT_SCORE = 650;
    uint256 public constant EXCELLENT_SCORE = 850;
    
    event LoanApproved(address indexed borrower, uint256 amount, uint256 rate);
    event LoanRejected(address indexed borrower, uint256 creditScore);
    
    constructor(address _oracleAddress) {
        auraOracle = IAuraOracle(_oracleAddress);
    }
    
    function requestLoan(uint256 amount) external returns (bool) {
        uint256 creditScore = auraOracle.getCreditScore(msg.sender);
        
        if (creditScore < MIN_CREDIT_SCORE) {
            emit LoanRejected(msg.sender, creditScore);
            return false;
        }
        
        uint256 interestRate = calculateInterestRate(creditScore);
        
        // Process loan...
        emit LoanApproved(msg.sender, amount, interestRate);
        return true;
    }
    
    function calculateInterestRate(uint256 creditScore) public pure returns (uint256) {
        if (creditScore >= EXCELLENT_SCORE) {
            return 500; // 5.00%
        } else if (creditScore >= 750) {
            return 700; // 7.00%
        } else if (creditScore >= MIN_CREDIT_SCORE) {
            return 1000; // 10.00%
        }
        return 1500; // 15.00%
    }
    
    function getMaxLoanAmount(address borrower) external view returns (uint256) {
        uint256 creditScore = auraOracle.getCreditScore(borrower);
        
        if (creditScore >= EXCELLENT_SCORE) {
            return 100 ether;
        } else if (creditScore >= 750) {
            return 50 ether;
        } else if (creditScore >= MIN_CREDIT_SCORE) {
            return 10 ether;
        }
        return 0;
    }
}
```

### 3. DAO Voting with Reputation

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./IAuraOracle.sol";

contract AuraDAO {
    IAuraOracle public auraOracle;
    
    struct Proposal {
        string description;
        uint256 forVotes;
        uint256 againstVotes;
        uint256 deadline;
        bool executed;
    }
    
    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    uint256 public proposalCount;
    
    constructor(address _oracleAddress) {
        auraOracle = IAuraOracle(_oracleAddress);
    }
    
    function vote(uint256 proposalId, bool support) external {
        require(!hasVoted[proposalId][msg.sender], "Already voted");
        require(block.timestamp < proposals[proposalId].deadline, "Voting ended");
        
        // Calculate voting power based on credit score
        uint256 creditScore = auraOracle.getCreditScore(msg.sender);
        uint256 votingPower = calculateVotingPower(creditScore);
        
        if (support) {
            proposals[proposalId].forVotes += votingPower;
        } else {
            proposals[proposalId].againstVotes += votingPower;
        }
        
        hasVoted[proposalId][msg.sender] = true;
    }
    
    function calculateVotingPower(uint256 creditScore) public pure returns (uint256) {
        // Base vote = 1, bonus based on credit score
        // 850+ score = 2x voting power
        // 750+ score = 1.5x voting power
        // 650+ score = 1.2x voting power
        // <650 score = 1x voting power
        
        if (creditScore >= 850) {
            return 2 ether;
        } else if (creditScore >= 750) {
            return 1.5 ether;
        } else if (creditScore >= 650) {
            return 1.2 ether;
        }
        return 1 ether;
    }
}
```

---

## 🧪 Testing Examples

### Jest Test (JavaScript)

```javascript
const axios = require('axios');
const { generateProof, verifyProof, queryPassport } = require('./aura-api');

jest.mock('axios');

describe('Aura API', () => {
  test('should generate proof successfully', async () => {
    const mockResponse = {
      data: {
        success: true,
        proof: {
          proof_hash: '0x123...',
          metadata: { credit_score: 750 }
        }
      }
    };
    
    axios.post.mockResolvedValue(mockResponse);
    
    const result = await generateProof('0xUser', '0xUser');
    
    expect(result.success).toBe(true);
    expect(result.proofHash).toBe('0x123...');
  });
  
  test('should handle API errors', async () => {
    axios.post.mockRejectedValue({
      response: { status: 403, data: { detail: 'Invalid API key' } }
    });
    
    const result = await generateProof('0xUser', '0xUser');
    
    expect(result.success).toBe(false);
    expect(result.error).toContain('Invalid API key');
  });
});
```

---

**More examples coming soon!**

For questions, visit our [Discord](https://discord.gg/auraprotocol) or check the [Integration Guide](./INTEGRATION_GUIDE.md).
