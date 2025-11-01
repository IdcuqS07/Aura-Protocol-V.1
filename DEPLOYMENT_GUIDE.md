# 🚀 Deployment Guide - Polygon Amoy Testnet

## Prerequisites

1. **MetaMask Wallet** with Polygon Amoy network added
2. **Test MATIC** from faucet
3. **Private Key** for deployment
4. **PolygonScan API Key** (optional, for verification)

## Step 1: Get Test MATIC

```bash
# Visit Polygon Faucet
https://faucet.polygon.technology/

# Select: Polygon Amoy
# Enter your wallet address
# Request test MATIC
```

## Step 2: Configure Environment

```bash
cd contracts
cp .env.example .env
```

Edit `.env`:
```env
PRIVATE_KEY=your_actual_private_key_here
POLYGONSCAN_API_KEY=your_polygonscan_api_key
POLYGON_RPC_URL=https://rpc-amoy.polygon.technology
POLYGON_CHAIN_ID=80002
```

## Step 3: Deploy Smart Contracts

```bash
# Compile contracts
npx hardhat compile

# Deploy to Polygon Amoy
npx hardhat run scripts/deploy.js --network polygon-amoy
```

**Expected Output:**
```
Deploying Aura Protocol contracts to Polygon testnet...
Deploying contracts with account: 0x...
Account balance: 1000000000000000000

Deploying SimpleZKBadge...
SimpleZKBadge deployed to: 0x...

Deploying ProofRegistry...
ProofRegistry deployed to: 0x...

Deployment info saved to deployment.json
```

## Step 4: Verify Contracts (Optional)

```bash
npx hardhat verify --network polygon-amoy <CONTRACT_ADDRESS>
```

## Step 5: Update Backend Configuration

Copy contract addresses from `deployment.json` to `backend/.env`:

```env
ZK_BADGE_CONTRACT="0x..."
PROOF_REGISTRY_CONTRACT="0x..."
```

## Step 6: Test Deployment

```bash
# Test contract interaction
npx hardhat console --network polygon-amoy

# In console:
const badge = await ethers.getContractAt("SimpleZKBadge", "0x...")
await badge.totalSupply()
```

## Step 7: Verify on Explorer

Visit: https://amoy.polygonscan.com/address/YOUR_CONTRACT_ADDRESS

Check:
- ✅ Contract deployed
- ✅ Transactions visible
- ✅ Contract verified (if step 4 completed)

## Troubleshooting

### Insufficient Funds
```
Error: insufficient funds for gas
```
**Solution**: Get more test MATIC from faucet

### Nonce Too Low
```
Error: nonce has already been used
```
**Solution**: Reset MetaMask account or wait for pending tx

### Network Error
```
Error: could not detect network
```
**Solution**: Check RPC URL and internet connection

## Production Checklist

- [ ] Contracts deployed to Amoy testnet
- [ ] Contract addresses updated in backend
- [ ] Contracts verified on PolygonScan
- [ ] Test minting badges
- [ ] Test proof generation
- [ ] Frontend connected to contracts
- [ ] API endpoints tested
- [ ] Documentation updated

## Next: Mainnet Deployment

When ready for mainnet:
1. Update network to `polygon` in hardhat.config.js
2. Use mainnet RPC: `https://polygon-rpc.com`
3. Chain ID: 137
4. Get real MATIC
5. Deploy with production private key

---

**⚠️ Security Warning**: Never commit private keys to git!
