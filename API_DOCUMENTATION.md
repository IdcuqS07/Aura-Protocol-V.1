# 📡 Aura Protocol - Proof-as-a-Service API Documentation

**Version**: 1.0.0  
**Base URL**: `https://api.auraprotocol.com` (Production) | `http://localhost:9000` (Development)

---

## 🔑 Authentication

All API endpoints require an API key in the request header:

```
X-API-Key: your_api_key_here
```

### Get Your API Key

1. Visit [https://www.aurapass.xyz/api](https://www.aurapass.xyz/api)
2. Connect your wallet
3. Generate an API key

### Rate Limits

| Tier | Requests/Day | Price |
|------|--------------|-------|
| Free | 100 | $0 |
| Pro | 1,000 | $29/mo |
| Enterprise | 10,000 | $199/mo |

---

## 📚 Endpoints

### 1. Generate ZK Proof

Generate a zero-knowledge proof for a user's credit passport.

**Endpoint**: `POST /api/v1/proof/generate`

**Headers**:
```
X-API-Key: your_api_key
Content-Type: application/json
```

**Request Body**:
```json
{
  "user_id": "0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1",
  "wallet_address": "0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"
}
```

**Response** (200 OK):
```json
{
  "success": true,
  "proof": {
    "proof_hash": "0x57e519608a7d5a03053f12e16749a13044d5a39390ffdf65d4a997c0113a8e91",
    "proof_type": "zk_credit_passport",
    "generated_at": "2025-01-07T08:26:26.372890",
    "is_valid": true,
    "metadata": {
      "credit_score": 750,
      "risk_level": "low"
    }
  },
  "timestamp": "2025-01-07T08:26:26.383147+00:00"
}
```

**Error Responses**:
- `403 Forbidden`: Invalid API key
- `404 Not Found`: User not found
- `429 Too Many Requests`: Rate limit exceeded
- `500 Internal Server Error`: Server error

---

### 2. Verify ZK Proof

Verify the validity of a zero-knowledge proof.

**Endpoint**: `POST /api/v1/proof/verify`

**Headers**:
```
X-API-Key: your_api_key
Content-Type: application/json
```

**Request Body**:
```json
{
  "proof_hash": "0x57e519608a7d5a03053f12e16749a13044d5a39390ffdf65d4a997c0113a8e91",
  "user_id": "0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"
}
```

**Response** (200 OK):
```json
{
  "success": true,
  "is_valid": true,
  "proof_hash": "0x57e519608a7d5a03053f12e16749a13044d5a39390ffdf65d4a997c0113a8e91",
  "verified_at": "2025-01-07T08:30:15.123456+00:00"
}
```

---

### 3. Query Credit Passport

Retrieve a user's credit passport information.

**Endpoint**: `POST /api/v1/passport/query`

**Headers**:
```
X-API-Key: your_api_key
Content-Type: application/json
```

**Request Body**:
```json
{
  "wallet_address": "0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"
}
```

**Response** (200 OK):
```json
{
  "success": true,
  "passport": {
    "passport_id": "PASS-A9CE18314BA4",
    "credit_score": 750,
    "grade": "Very Good",
    "risk_level": "low",
    "poh_score": 85,
    "badge_count": 5,
    "issued_at": "2025-01-01T00:00:00+00:00",
    "last_updated": "2025-01-07T08:00:00+00:00"
  },
  "timestamp": "2025-01-07T08:35:20.456789+00:00"
}
```

---

### 4. Health Check

Check API service status.

**Endpoint**: `GET /api/v1/health`

**Headers**: None required

**Response** (200 OK):
```json
{
  "status": "healthy",
  "service": "Aura Protocol Public API",
  "version": "1.0.0",
  "timestamp": "2025-01-07T08:40:00.000000+00:00"
}
```

---

## 🔐 Security Best Practices

1. **Never expose your API key** in client-side code
2. **Use environment variables** to store API keys
3. **Rotate keys regularly** (every 90 days recommended)
4. **Monitor usage** to detect unauthorized access
5. **Use HTTPS** in production

---

## 📊 Credit Score Grades

| Score Range | Grade | Risk Level |
|-------------|-------|------------|
| 850-1000 | Excellent | Low |
| 750-849 | Very Good | Low |
| 650-749 | Good | Medium |
| 550-649 | Fair | Medium |
| 0-549 | Poor | High |

---

## 🚨 Error Codes

| Code | Message | Description |
|------|---------|-------------|
| 400 | Bad Request | Invalid request parameters |
| 403 | Forbidden | Invalid or missing API key |
| 404 | Not Found | Resource not found |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Server error |

---

## 💡 Use Cases

### DeFi Lending Protocol
```
1. User applies for loan
2. Your dApp calls /api/v1/passport/query
3. Check credit_score and risk_level
4. Approve/reject loan based on score
```

### NFT Marketplace
```
1. Seller lists NFT
2. Call /api/v1/proof/generate for seller
3. Display proof badge on listing
4. Buyers can verify seller reputation
```

### DAO Governance
```
1. Member proposes vote
2. Query member's credit passport
3. Weight vote based on credit_score
4. Higher scores = more voting power
```

---

## 🔗 Resources

- **API Dashboard**: https://www.aurapass.xyz/api
- **GitHub**: https://github.com/IdcuqS07/Aura-Protocol-V.1
- **Support**: support@auraprotocol.com
- **Discord**: https://discord.gg/auraprotocol

---

## 📝 Changelog

### v1.0.0 (2025-01-07)
- Initial release
- Proof generation endpoint
- Proof verification endpoint
- Passport query endpoint
- API key authentication
- Rate limiting

---

**Need help?** Check our [Integration Guide](./INTEGRATION_GUIDE.md) or [Code Examples](./CODE_EXAMPLES.md)
