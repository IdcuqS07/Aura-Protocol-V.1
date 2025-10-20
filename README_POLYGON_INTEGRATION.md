# Aura Protocol - Polygon Testnet Integration

## Overview

Integrasi Aura Protocol dengan Polygon testnet untuk fitur-fitur:
- **Proof of Uniqueness**: ZK proof untuk membuktikan keunikan identitas
- **ZK Identity Layer**: Layer identitas berbasis Zero-Knowledge
- **Civic Integration**: Integrasi dengan Civic untuk verifikasi identitas
- **Worldcoin Integration**: Integrasi dengan Worldcoin untuk proof of personhood
- **ZK-ID Badge Launch**: Peluncuran soulbound NFT sebagai badge identitas

## Smart Contracts

### 1. AuraZKBadge.sol
- **Fungsi**: Soulbound NFT untuk ZK-ID badges
- **Fitur**:
  - Badge types: UNIQUENESS, IDENTITY, REPUTATION, CIVIC, WORLDCOIN
  - Proof of uniqueness (mencegah duplikasi proof)
  - Soulbound (tidak bisa ditransfer)
  - Authorized verifiers untuk setiap badge type

### 2. CivicIntegration.sol
- **Fungsi**: Integrasi dengan Civic Gateway Token
- **Fitur**:
  - Verifikasi identitas melalui Civic
  - Issue ZK Badge untuk Civic verification
  - Tracking status verifikasi

### 3. WorldcoinIntegration.sol
- **Fungsi**: Integrasi dengan Worldcoin World ID
- **Fitur**:
  - Verifikasi proof of personhood
  - ZK proof verification dengan WorldID
  - Nullifier hash untuk mencegah double-spending

## Deployment

### Prerequisites
```bash
cd contracts
npm install
```

### Environment Setup
```bash
cp .env.example .env
# Edit .env dengan private key dan API keys
```

### Deploy ke Polygon Mumbai
```bash
npx hardhat compile
npx hardhat run scripts/deploy.js --network polygon-mumbai
```

## Backend Integration

### Dependencies
```bash
pip install web3 eth-account
```

### Blockchain Module
- `blockchain.py`: Modul untuk interaksi dengan smart contracts
- Fungsi utama:
  - `issue_zk_badge()`: Issue ZK Badge on-chain
  - `verify_civic_proof()`: Verifikasi Civic dan issue badge
  - `verify_worldcoin_proof()`: Verifikasi Worldcoin dan issue badge
  - `check_user_badges()`: Cek badge yang dimiliki user

### API Endpoints
- `POST /api/blockchain/civic-verify`: Verifikasi dengan Civic
- `POST /api/blockchain/worldcoin-verify`: Verifikasi dengan Worldcoin
- `GET /api/blockchain/badges/{wallet_address}`: Get user badges

## Frontend Integration

### Komponen Baru
1. **ZKVerification.js**: Interface untuk Civic dan Worldcoin verification
2. **ProofOfUniqueness.js**: Interface untuk generate proof of uniqueness

### Fitur
- Wallet connection integration
- Real-time verification status
- ZK Badge display
- Progress tracking untuk proof generation

## Polygon Testnet Configuration

### Network Details
- **Chain ID**: 80001 (Mumbai) / 80002 (Amoy)
- **RPC URL**: https://rpc-mumbai.maticvigil.com
- **Explorer**: https://mumbai.polygonscan.com

### Faucet
- Mumbai Faucet: https://faucet.polygon.technology/
- Minimum MATIC diperlukan untuk gas fees

## Testing

### Manual Testing
1. Connect wallet ke aplikasi
2. Navigate ke `/zk-verification`
3. Test Civic verification
4. Test Worldcoin verification
5. Navigate ke `/proof-uniqueness`
6. Generate proof of uniqueness
7. Verify badges di blockchain explorer

### Contract Verification
```bash
npx hardhat verify --network polygon-mumbai <CONTRACT_ADDRESS>
```

## Security Considerations

1. **Private Key Management**: Jangan commit private keys
2. **Proof Validation**: Validate semua ZK proofs sebelum issue badge
3. **Nullifier Tracking**: Prevent double-spending dengan nullifier hashes
4. **Access Control**: Hanya authorized verifiers yang bisa issue badges

## Production Deployment

### Mainnet Configuration
- Update RPC URLs ke Polygon mainnet
- Update contract addresses
- Implement proper key management
- Add monitoring dan alerting

### Integration Checklist
- [ ] Deploy smart contracts ke testnet
- [ ] Update contract addresses di backend
- [ ] Test semua verification flows
- [ ] Verify contracts di explorer
- [ ] Test frontend integration
- [ ] Deploy ke production

## Troubleshooting

### Common Issues
1. **Gas Estimation Failed**: Increase gas limit
2. **Nonce Too Low**: Reset MetaMask account
3. **Contract Not Found**: Verify contract address
4. **RPC Error**: Check network connection

### Debug Commands
```bash
# Check contract deployment
npx hardhat console --network polygon-mumbai

# Verify transaction
npx hardhat run scripts/verify-tx.js --network polygon-mumbai
```