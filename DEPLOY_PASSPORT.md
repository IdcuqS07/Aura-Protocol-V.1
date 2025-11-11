# Deploy Credit Passport Backend

## Quick Deploy

```bash
ssh root@159.65.134.137 << 'EOF'
cd /root/Aura-Protocol-V.1-main/backend
git pull
sudo systemctl restart aura-backend
sleep 3
sudo systemctl status aura-backend
EOF
```

## Test After Deploy

```bash
# Test calculate score
curl -X POST https://www.aurapass.xyz/api/passport/calculate-score \
  -H "Content-Type: application/json" \
  -d '{"wallet_address": "0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"}' | python3 -m json.tool

# Test get passport (will 404 if not minted)
curl https://www.aurapass.xyz/api/passport/0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1 | python3 -m json.tool
```

## Contract Info

- **Address**: `0xbAEe1fC5e41adB7aB303a23907cDEFAEf0aD763c`
- **Network**: Polygon Amoy
- **Explorer**: https://amoy.polygonscan.com/address/0xbAEe1fC5e41adB7aB303a23907cDEFAEf0aD763c

## Endpoints

1. `POST /api/passport/calculate-score` - Calculate credit score
2. `POST /api/passport/store` - Store passport after mint
3. `GET /api/passport/{wallet_address}` - Get passport data
