# Aura Protocol V.1

[![Live Demo](https://img.shields.io/badge/demo-live-success)](https://www.aurapass.xyz/)
[![License](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

Universal Trust in a Trustless World - Polygon ZK-ID Credit Layer

## 🌟 Overview

Aura Protocol is a decentralized credibility layer that builds **ZK Credit Passports** — on-chain financial identities that verify reputation without revealing personal data.

**Live Demo**: [https://www.aurapass.xyz/](https://www.aurapass.xyz/)

## ✨ Wave 2 Features (Latest)

- ✅ **Soulbound NFT**: Non-transferable ZK-ID badges
- ✅ **Proof-as-a-Service API**: Generate and verify ZK proofs
- ✅ **Premium Features**: Tiered pricing with API key management
- ✅ **ProofRegistry Contract**: On-chain proof verification
- ✅ **API Key Authentication**: Secure access with rate limiting

## 🛠️ Tech Stack

- **Frontend**: React, TailwindCSS, shadcn/ui, React Router
- **Backend**: FastAPI (Python), MongoDB
- **Blockchain**: Solidity, Hardhat, OpenZeppelin
- **Network**: Polygon (Amoy Testnet)
- **Testing**: Hardhat, Pytest

## Prerequisites

- Python 3.8+
- Node.js 18+
- MongoDB
- Yarn

## Installation

### Backend Setup

```bash
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Frontend Setup

```bash
cd frontend
yarn install
```

## Configuration

### Backend (.env)

```
MONGO_URL=mongodb://localhost:27017
DB_NAME=aura_protocol
CORS_ORIGINS=*
```

### Frontend (.env)

```
REACT_APP_BACKEND_URL=http://localhost:9000
```

## Running the Application

### Start MongoDB

```bash
brew services start mongodb/brew/mongodb-community
```

### Start Backend

```bash
cd backend
source venv/bin/activate
uvicorn server:app --reload --host 0.0.0.0 --port 9000
```

### Start Frontend

```bash
cd frontend
yarn start
```

Access the application at `http://localhost:3000`

## 🎯 Core Features

### Wave 1: Foundation
- ✅ **Proof of Uniqueness**: ZK proof generation
- ✅ **ZK Identity Layer**: Decentralized identity system
- ✅ **Civic & Worldcoin Integration**: Multi-provider verification
- ✅ **ZK-ID Badge Launch**: Soulbound NFT badges

### Wave 2: ZK Credit Passport (Complete ✅)
- ✅ **Credit Passport NFT**: On-chain financial identity
- ✅ **Proof-as-a-Service API**: `/proof/generate` & `/proof/verify`
- ✅ **Analytics Dashboard**: Real-time ecosystem metrics
- ✅ **Premium Features**: Free, Pro ($29/mo), Enterprise ($199/mo)
- ✅ **Smart Contracts Deployed**: Polygon Amoy testnet
- ✅ **Civic & Worldcoin Integration**: Identity verification UI

### Wave 3: Expansion (Coming Soon)
- 🔄 **Cross-Chain Layer (AuraX)**: Multi-chain support
- 🔄 **AI Risk Oracle**: ML-powered risk assessment
- 🔄 **Reputation DAO**: Decentralized governance
- 🔄 **Multi-Chain Support**: Beyond Polygon

## 📡 API Endpoints

### User Management
- `POST /api/users` - Create user
- `GET /api/users/{user_id}` - Get user
- `POST /api/users/{user_id}/verify` - Verify identity

### Passport & Badges
- `POST /api/passports` - Create credit passport
- `GET /api/passports/{user_id}` - Get passport
- `GET /api/badges/{user_id}` - Get user badges

### Proof-as-a-Service (Requires API Key)
- `POST /api/proof/generate` - Generate ZK proof
- `POST /api/proof/verify` - Verify ZK proof

### Blockchain
- `POST /api/blockchain/civic-verify` - Civic verification
- `POST /api/blockchain/worldcoin-verify` - Worldcoin verification
- `GET /api/blockchain/badges/{wallet_address}` - Get on-chain badges

### Analytics
- `GET /api/analytics` - Get ecosystem analytics

## 🔑 API Authentication

```bash
curl -X POST https://api.auraprotocol.com/proof/generate \
  -H "X-API-Key: your_api_key" \
  -H "Content-Type: application/json" \
  -d '{"user_id": "user_123"}'
```

**Demo API Keys:**
- `demo_key_12345` - 100 requests/day
- `premium_key_67890` - 1000 requests/day

## 🧪 Smart Contracts

### Deployed Contracts
- **SimpleZKBadge**: Soulbound NFT for ZK-ID badges
- **ProofRegistry**: On-chain proof verification

### Testing
```bash
cd contracts
npx hardhat test
```

### Deployment
```bash
npx hardhat run scripts/deploy.js --network localhost
```

## 📚 Documentation

- [Deployment Guide](DEPLOYMENT_GUIDE.md) - Deploy to Polygon Amoy
- [Polygon Integration Guide](README_POLYGON_INTEGRATION.md)
- [Integration Summary](INTEGRATION_SUMMARY.md)
- [Wave 2 To-Do List](Wave2-TODO.md)
- [Contributing Guidelines](CONTRIBUTING.md)

## 🗺️ Roadmap

Visit [/roadmap](https://www.aurapass.xyz/roadmap) for detailed development timeline.

## 🤝 Contributing

Contributions are welcome! Please read our contributing guidelines.

## 📄 License

MIT License - see [LICENSE](LICENSE) for details

## 🔗 Links

- **Live Demo**: https://www.aurapass.xyz/
- **GitHub**: https://github.com/IdcuqS07/Aura-Protocol-V.1
- **Testnet Guide**: [/testnet](https://www.aurapass.xyz/testnet)

---

**Built with ❤️ for Polygon zkEVM**
