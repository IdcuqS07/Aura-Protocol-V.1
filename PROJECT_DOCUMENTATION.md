# 📚 Aura Protocol - Project Documentation

**Version:** 1.0  
**Last Updated:** November 1, 2025  
**Status:** Wave 1 & 2 Complete | Wave 3 & 4 Planned

---

## 📋 TABLE OF CONTENTS

1. [Executive Summary](#executive-summary)
2. [What Has Been Completed](#what-has-been-completed)
3. [Wave 3: Expansion (Planned)](#wave-3-expansion)
4. [Wave 4: Monetization & Scale (Planned)](#wave-4-monetization)
5. [Technical Architecture](#technical-architecture)
6. [Deployment Guide](#deployment-guide)

---

## 🎯 EXECUTIVE SUMMARY

### Project Overview
Aura Protocol adalah platform identitas digital terdesentralisasi yang memungkinkan pengguna membangun reputasi on-chain melalui ZK-ID Badges (Soulbound NFTs). Platform ini menyediakan Credit Passport system untuk financial identity dan Proof-as-a-Service API untuk integrasi dengan aplikasi lain.

### Current Status
- **Live URL:** https://www.aurapass.xyz
- **Network:** Polygon Amoy Testnet
- **Completion:** 66% (Wave 1 & 2 Complete)
- **Users:** Ready for production use

---

## ✅ WHAT HAS BEEN COMPLETED

### WAVE 1: FOUNDATION (100% COMPLETE)

#### 1.1 Smart Contracts
**SimpleZKBadge Contract**
- **Address:** `0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678`
- **Type:** ERC721 Soulbound NFT
- **Features:**
  - Non-transferable badges
  - 5 badge types (Uniqueness, Identity, Reputation, Civic, Worldcoin)
  - Minter authorization system
  - ZK proof hash storage
  - Event emissions for tracking

**ProofRegistry Contract**
- **Address:** `0x296DB144E62C8C826bffA4503Dc9Fbf29F25D44B`
- **Features:**
  - On-chain proof storage
  - Proof verification
  - Timestamp tracking

#### 1.2 Frontend Application
**Pages Implemented:**
- Landing Page - Hero, features, CTA
- Dashboard - User profile, badges, credit score
- Verify Identity - 5 badge verification methods
- ZK Badges - Badge gallery
- Credit Passport - Financial identity display
- Analytics - Ecosystem metrics
- Premium - Pricing tiers
- Roadmap - Development timeline
- Testnet Guide - User instructions
- Admin Monitoring - System stats

**Features:**
- MetaMask wallet integration
- Auto network switching to Polygon Amoy
- Signature-based authentication
- Real-time data updates
- Responsive design (mobile-friendly)
- Dark theme with gradients
- Loading states & error handling

#### 1.3 Identity Verification System
**Verification Methods:**
1. Proof of Uniqueness - Base verification
2. Identity Verified - Digital identity
3. Reputation Badge - On-chain reputation
4. Civic Verified - KYC-level verification
5. Worldcoin Verified - Biometric proof

**Flow:**
```
User connects wallet
↓
Selects verification method
↓
Signs message (no gas fee)
↓
Backend verifies signature
↓
Backend mints badge
↓
Badge appears on-chain
```

---

### WAVE 2: ZK CREDIT PASSPORT (100% COMPLETE)

#### 2.1 Backend API (FastAPI)
**Core Endpoints:**
```
User Management:
- POST /api/users - Create user
- GET /api/users/{id} - Get user
- POST /api/users/{id}/verify - Verify identity

Badge System:
- POST /api/badges/mint - Mint badge (signature verified)
- GET /api/badges/demo/{address} - Get demo badges

Passport:
- POST /api/passports - Create passport
- GET /api/passports/{user_id} - Get passport

Analytics:
- GET /api/analytics - Ecosystem metrics

Proof-as-a-Service:
- POST /api/proof/generate - Generate ZK proof (API key required)
- POST /api/proof/verify - Verify ZK proof (API key required)

Blockchain:
- POST /api/blockchain/civic-verify - Civic verification
- POST /api/blockchain/worldcoin-verify - Worldcoin verification
- GET /api/blockchain/badges/{address} - Get on-chain badges
```

**Features:**
- MongoDB integration
- API key authentication
- Rate limiting per tier
- Signature verification
- Protocol-controlled minting
- CORS configuration
- Swagger documentation

#### 2.2 Credit Passport System
**Components:**
- Passport ID (unique identifier)
- Credit Score (0-1000)
- Reputation Score (0-100)
- Risk Level (Low/Medium/High)
- Soulbound Token ID
- ZK Proof Hash
- Transaction history

**Calculation Logic:**
```javascript
Credit Score = Base Score (650) + 
               (Badges × 25) + 
               (Transactions × 5) +
               (Reputation × 2)

Risk Level = 
  Score >= 750 → Low Risk
  Score >= 600 → Medium Risk
  Score < 600 → High Risk
```

#### 2.3 Proof-as-a-Service API
**Pricing Tiers:**
- **Free:** 100 requests/day, $0/month
- **Pro:** 1,000 requests/day, $29/month
- **Enterprise:** 10,000 requests/day, $199/month

**Use Cases:**
- DeFi protocols verify user reputation
- DAOs check member credentials
- Marketplaces verify seller trust
- Lending platforms assess credit risk

#### 2.4 Analytics Dashboard
**Metrics Tracked:**
- Total Users
- Verified Users
- Credit Passports Issued
- Average Credit Score
- Transaction Volume
- Risk Distribution
- Verification Rate
- Passport Adoption Rate

**Data Sources:**
- MongoDB (users, badges, passports)
- Blockchain (on-chain badges)
- Real-time calculations

#### 2.5 Backend Minting System
**Architecture:**
```
User Request → Signature Verification → Backend Mints → On-chain Badge
```

**Benefits:**
- No gas fees for users
- Protocol controls badge issuance
- Maintains badge credibility
- Prevents spam/abuse
- User proves ownership via signature

**Implementation:**
```python
# User signs message
message = f"Verify identity for {badge_type}"
signature = user_wallet.sign(message)

# Backend verifies
recovered = web3.eth.account.recover(message, signature)
if recovered == user_address:
    # Backend mints with deployer wallet
    tx = contract.issueBadge(user_address, badge_type, proof_hash)
```

---

### DEPLOYMENT (100% COMPLETE)

#### Production Environment
**Frontend:**
- URL: https://www.aurapass.xyz
- Server: VPS (159.65.134.137)
- Web Server: Nginx
- SSL: Cloudflare HTTPS
- CDN: Cloudflare proxy

**Backend:**
- Server: Same VPS
- Port: 9000
- Framework: FastAPI
- Database: MongoDB (local)
- Process: systemd/nohup

**Blockchain:**
- Network: Polygon Amoy Testnet
- Chain ID: 80002
- RPC: https://rpc-amoy.polygon.technology
- Explorer: https://amoy.polygonscan.com

#### Infrastructure
- VPS: Ubuntu/Debian
- Nginx reverse proxy
- SSL certificate (Cloudflare)
- Domain: aurapass.xyz
- MongoDB: v6.0+
- Python: 3.8+
- Node.js: 18+

---

## 🚀 WAVE 3: EXPANSION (PLANNED)

### 3.1 Cross-Chain Layer (AuraX)

#### Objective
Enable Aura Protocol badges and credit passports to work across multiple blockchain networks, creating a unified identity layer.

#### Features to Implement

**A. Multi-Chain Support**
```
Supported Networks:
- Ethereum Mainnet
- Polygon (already done)
- Arbitrum
- Optimism
- Base
- BSC (Binance Smart Chain)
```

**B. Bridge Contracts**
```solidity
contract AuraXBridge {
    // Lock badge on source chain
    function lockBadge(uint256 tokenId, uint256 targetChain);
    
    // Mint wrapped badge on target chain
    function mintWrappedBadge(uint256 tokenId, address owner);
    
    // Burn wrapped badge
    function burnWrappedBadge(uint256 tokenId);
    
    // Unlock original badge
    function unlockBadge(uint256 tokenId);
}
```

**C. Unified Identity**
- Single wallet address across all chains
- Badge verification works on any chain
- Credit score aggregated from all chains
- Cross-chain reputation tracking

**D. Implementation Plan**
```
Phase 1: Deploy bridge contracts (2 weeks)
Phase 2: Implement cross-chain messaging (LayerZero/Axelar) (3 weeks)
Phase 3: Update frontend for multi-chain (2 weeks)
Phase 4: Testing & audit (2 weeks)
Total: ~9 weeks
```

**E. Technical Stack**
- LayerZero or Axelar for cross-chain messaging
- Chainlink CCIP for secure transfers
- Multi-chain RPC providers
- Chain-specific contract deployments

---

### 3.2 AI Risk Oracle

#### Objective
Implement machine learning model untuk assess credit risk secara real-time dan provide on-chain risk scores.

#### Features to Implement

**A. ML Risk Model**
```python
class RiskAssessmentModel:
    def __init__(self):
        self.model = load_trained_model()
    
    def assess_risk(self, user_data):
        features = extract_features(user_data)
        # Features: badges, transactions, wallet age, etc.
        
        risk_score = self.model.predict(features)
        # Output: 0-100 (0 = highest risk, 100 = lowest risk)
        
        return {
            'risk_score': risk_score,
            'risk_level': categorize_risk(risk_score),
            'confidence': model_confidence,
            'factors': contributing_factors
        }
```

**B. Data Sources**
- On-chain transaction history
- Badge ownership & types
- Wallet age & activity
- DeFi protocol interactions
- NFT holdings
- Token balances
- Historical credit score

**C. Oracle Contract**
```solidity
contract AuraRiskOracle {
    struct RiskAssessment {
        uint256 riskScore;
        uint256 timestamp;
        string riskLevel;
        bool isValid;
    }
    
    mapping(address => RiskAssessment) public assessments;
    
    function updateRiskScore(address user, uint256 score) external onlyOracle;
    function getRiskScore(address user) external view returns (uint256);
}
```

**D. Implementation Plan**
```
Phase 1: Data collection & labeling (3 weeks)
Phase 2: Model training & validation (4 weeks)
Phase 3: Oracle contract deployment (2 weeks)
Phase 4: Backend integration (2 weeks)
Phase 5: Testing & optimization (2 weeks)
Total: ~13 weeks
```

**E. ML Stack**
- Python: scikit-learn, TensorFlow
- Features: 20+ on-chain metrics
- Model: Random Forest / Neural Network
- Accuracy target: >85%
- Update frequency: Daily

---

### 3.3 Reputation DAO

#### Objective
Create decentralized governance system where community can vote on badge verifications, protocol upgrades, and treasury management.

#### Features to Implement

**A. Governance Token (AURA)**
```solidity
contract AuraToken is ERC20, ERC20Votes {
    // Total Supply: 1,000,000,000 AURA
    // Distribution:
    // - 40% Community rewards
    // - 25% Team & advisors (4-year vesting)
    // - 20% Treasury
    // - 10% Liquidity
    // - 5% Early supporters
}
```

**B. DAO Contract**
```solidity
contract AuraDAO {
    struct Proposal {
        uint256 id;
        address proposer;
        string description;
        uint256 forVotes;
        uint256 againstVotes;
        uint256 startBlock;
        uint256 endBlock;
        bool executed;
    }
    
    function propose(string memory description) external returns (uint256);
    function vote(uint256 proposalId, bool support) external;
    function execute(uint256 proposalId) external;
    function delegate(address delegatee) external;
}
```

**C. Governance Features**
- **Badge Verification Voting**
  - Community votes on disputed badges
  - Threshold: 51% approval
  - Voting period: 7 days

- **Protocol Upgrades**
  - Propose contract upgrades
  - Threshold: 66% approval
  - Timelock: 48 hours

- **Treasury Management**
  - Allocate funds for development
  - Grant programs
  - Marketing initiatives

- **Parameter Changes**
  - Credit score formulas
  - Badge requirements
  - Fee structures

**D. Voting Power**
```
Voting Power = AURA Tokens + Badge Multiplier

Badge Multiplier:
- 5 badges: 1.5x
- 10 badges: 2x
- 20 badges: 3x
```

**E. Implementation Plan**
```
Phase 1: Token contract deployment (2 weeks)
Phase 2: DAO contract & governance (3 weeks)
Phase 3: Frontend governance UI (3 weeks)
Phase 4: Token distribution (2 weeks)
Phase 5: Testing & audit (3 weeks)
Total: ~13 weeks
```

---

### 3.4 Wave 3 Summary

**Timeline:** 20-25 weeks (5-6 months)

**Deliverables:**
- ✅ Multi-chain badge support (6+ chains)
- ✅ AI-powered risk assessment
- ✅ DAO governance system
- ✅ AURA governance token
- ✅ Cross-chain bridge
- ✅ ML risk oracle

**Resources Needed:**
- 2-3 Smart Contract Developers
- 1 ML Engineer
- 1 Backend Developer
- 1 Frontend Developer
- Security Audit: $50k-100k

---

## 💰 WAVE 4: MONETIZATION & SCALE (PLANNED)

### 4.1 Payment Integration

#### Objective
Enable fiat and crypto payments untuk premium subscriptions dan enterprise features.

#### Features to Implement

**A. Stripe Integration**
```javascript
// Subscription checkout
const session = await stripe.checkout.sessions.create({
  payment_method_types: ['card'],
  line_items: [{
    price: 'price_pro_monthly', // $29/month
    quantity: 1,
  }],
  mode: 'subscription',
  success_url: 'https://aurapass.xyz/success',
  cancel_url: 'https://aurapass.xyz/cancel',
});
```

**B. Crypto Payments**
```solidity
contract AuraPayments {
    // Accept USDC, MATIC, ETH
    function subscribePro(address token, uint256 amount) external;
    function subscribeEnterprise(address token, uint256 amount) external;
    
    // Pricing in stablecoins
    uint256 public constant PRO_PRICE = 29e6; // 29 USDC
    uint256 public constant ENTERPRISE_PRICE = 199e6; // 199 USDC
}
```

**C. Subscription Management**
```python
class SubscriptionManager:
    def create_subscription(user_id, tier, payment_method):
        # Create subscription
        # Generate API key
        # Set rate limits
        # Send confirmation email
        
    def cancel_subscription(user_id):
        # Cancel subscription
        # Revoke API key
        # Send cancellation email
        
    def upgrade_subscription(user_id, new_tier):
        # Prorate charges
        # Update API key limits
        # Send upgrade confirmation
```

**D. Implementation Plan**
```
Phase 1: Stripe integration (2 weeks)
Phase 2: Crypto payment contracts (2 weeks)
Phase 3: Subscription management (2 weeks)
Phase 4: Billing dashboard (2 weeks)
Phase 5: Testing (1 week)
Total: ~9 weeks
```

---

### 4.2 Enterprise Features

#### Objective
Provide advanced features untuk enterprise customers dengan custom requirements.

#### Features to Implement

**A. Custom Badge Types**
```javascript
// Enterprise can create custom badges
POST /api/enterprise/badges/create
{
  "badge_name": "Company Verified Employee",
  "badge_description": "Verified employee of Company X",
  "badge_criteria": {...},
  "badge_icon": "ipfs://...",
  "max_supply": 1000
}
```

**B. White-Label Solutions**
- Custom branding (logo, colors, domain)
- Embedded widget untuk websites
- Custom badge designs
- Branded API endpoints

**C. Advanced Analytics**
```javascript
// Enterprise analytics
GET /api/enterprise/analytics
{
  "total_badges_issued": 5000,
  "active_users": 3500,
  "verification_rate": 0.85,
  "average_credit_score": 780,
  "top_badge_types": [...],
  "user_demographics": {...},
  "retention_rate": 0.92
}
```

**D. Dedicated Support**
- Priority support channel
- Dedicated account manager
- Custom integration assistance
- SLA guarantees (99.9% uptime)

**E. Bulk Operations**
```javascript
// Bulk badge issuance
POST /api/enterprise/badges/bulk-mint
{
  "recipients": ["0x...", "0x...", ...],
  "badge_type": "Employee Verified",
  "metadata": {...}
}
```

**F. Implementation Plan**
```
Phase 1: Custom badge system (3 weeks)
Phase 2: White-label infrastructure (4 weeks)
Phase 3: Enterprise analytics (2 weeks)
Phase 4: Support system (2 weeks)
Phase 5: Bulk operations (2 weeks)
Total: ~13 weeks
```

---

### 4.3 Mobile Application

#### Objective
Create native mobile app untuk iOS dan Android dengan full Web3 functionality.

#### Features to Implement

**A. Core Features**
- Wallet integration (WalletConnect, MetaMask Mobile)
- Badge viewing & management
- QR code badge verification
- Push notifications
- Biometric authentication
- Offline mode

**B. Tech Stack**
```
Framework: React Native
State: Redux Toolkit
Web3: ethers.js / wagmi
Storage: AsyncStorage / MMKV
Push: Firebase Cloud Messaging
Analytics: Firebase Analytics
```

**C. Screens**
```
1. Onboarding
   - Welcome slides
   - Wallet setup
   - Permissions

2. Home
   - Badge gallery
   - Credit score widget
   - Quick actions

3. Verify
   - Camera for QR scan
   - Badge verification methods
   - Signature flow

4. Profile
   - User info
   - Credit passport
   - Settings

5. Notifications
   - Badge minted
   - Score updates
   - DAO proposals
```

**D. Mobile-Specific Features**
```javascript
// QR Code Scanning
import { Camera } from 'react-native-camera';

function ScanBadge() {
  const onBarCodeRead = (data) => {
    // Verify badge from QR code
    verifyBadge(data.data);
  };
  
  return <Camera onBarCodeRead={onBarCodeRead} />;
}

// Push Notifications
import messaging from '@react-native-firebase/messaging';

messaging().onMessage(async remoteMessage => {
  // Badge minted notification
  showNotification(remoteMessage);
});

// Biometric Auth
import TouchID from 'react-native-touch-id';

TouchID.authenticate('Unlock Aura Protocol')
  .then(success => {
    // Authenticated
  });
```

**E. Implementation Plan**
```
Phase 1: Project setup & navigation (2 weeks)
Phase 2: Wallet integration (3 weeks)
Phase 3: Core features (4 weeks)
Phase 4: Push notifications (2 weeks)
Phase 5: Testing & optimization (3 weeks)
Phase 6: App Store submission (2 weeks)
Total: ~16 weeks
```

---

### 4.4 Advanced Analytics & Monitoring

#### Objective
Implement comprehensive analytics dan monitoring untuk track user behavior, system performance, dan business metrics.

#### Features to Implement

**A. User Analytics**
```javascript
// Track user journey
analytics.track('Badge Minted', {
  badge_type: 'Civic Verified',
  user_id: 'user_123',
  timestamp: Date.now(),
  gas_saved: 0.05 // MATIC
});

// Funnel analysis
const funnel = {
  'Wallet Connected': 10000,
  'Identity Verified': 7500,
  'Badge Minted': 6000,
  'Passport Created': 4500
};
```

**B. System Monitoring**
```python
# Prometheus metrics
from prometheus_client import Counter, Histogram

badge_mints = Counter('badge_mints_total', 'Total badges minted')
api_latency = Histogram('api_request_duration_seconds', 'API latency')

@app.post("/api/badges/mint")
async def mint_badge():
    with api_latency.time():
        # Mint badge
        badge_mints.inc()
```

**C. Business Metrics Dashboard**
- Monthly Recurring Revenue (MRR)
- Customer Acquisition Cost (CAC)
- Lifetime Value (LTV)
- Churn rate
- API usage per tier
- Badge minting trends

**D. Error Tracking**
```javascript
// Sentry integration
import * as Sentry from "@sentry/react";

Sentry.init({
  dsn: "https://...",
  integrations: [new BrowserTracing()],
  tracesSampleRate: 1.0,
});
```

**E. Implementation Plan**
```
Phase 1: Analytics setup (Mixpanel/Amplitude) (1 week)
Phase 2: Monitoring (Prometheus/Grafana) (2 weeks)
Phase 3: Business metrics dashboard (2 weeks)
Phase 4: Error tracking (Sentry) (1 week)
Total: ~6 weeks
```

---

### 4.5 Wave 4 Summary

**Timeline:** 25-30 weeks (6-7 months)

**Deliverables:**
- ✅ Payment integration (Stripe + Crypto)
- ✅ Enterprise features & white-label
- ✅ Mobile app (iOS + Android)
- ✅ Advanced analytics & monitoring
- ✅ Subscription management
- ✅ Dedicated support system

**Resources Needed:**
- 2 Mobile Developers (React Native)
- 1 Backend Developer
- 1 DevOps Engineer
- 1 Product Manager
- Design: $20k-30k
- Marketing: $50k-100k

**Revenue Projections:**
```
Year 1:
- 100 Pro users × $29/mo = $2,900/mo
- 10 Enterprise × $199/mo = $1,990/mo
- Total: ~$60k/year

Year 2:
- 500 Pro users × $29/mo = $14,500/mo
- 50 Enterprise × $199/mo = $9,950/mo
- Total: ~$290k/year
```

---

## 🏗️ TECHNICAL ARCHITECTURE

### System Overview
```
┌─────────────────────────────────────────────────────────┐
│                    Frontend (React)                      │
│  Landing | Dashboard | Verify | Analytics | Premium     │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ HTTPS/WSS
                     │
┌────────────────────▼────────────────────────────────────┐
│              Backend API (FastAPI)                       │
│  Auth | Badges | Passports | Proofs | Analytics        │
└────────┬──────────────────────────────┬─────────────────┘
         │                              │
         │ MongoDB                      │ Web3.py
         │                              │
┌────────▼────────┐          ┌──────────▼─────────────────┐
│    MongoDB      │          │   Polygon Amoy Testnet     │
│  Users          │          │  SimpleZKBadge Contract    │
│  Badges         │          │  ProofRegistry Contract    │
│  Passports      │          │                            │
└─────────────────┘          └────────────────────────────┘
```

### Data Flow
```
User Action → Frontend → Backend → Verify Signature → Mint Badge → Blockchain
                                                                        ↓
                                                              Store in MongoDB
                                                                        ↓
                                                              Update Analytics
```

---

## 📦 DEPLOYMENT GUIDE

### Prerequisites
```bash
# Server requirements
- Ubuntu 20.04+ or Debian 11+
- 4GB RAM minimum
- 50GB storage
- Node.js 18+
- Python 3.8+
- MongoDB 6.0+
- Nginx
```

### Frontend Deployment
```bash
# Build
cd frontend
yarn install
yarn build

# Deploy
scp -r build/* root@vps:/var/www/aura-frontend/

# Nginx config
server {
    listen 80;
    server_name aurapass.xyz;
    root /var/www/aura-frontend;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

### Backend Deployment
```bash
# Setup
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Run
uvicorn server:app --host 0.0.0.0 --port 9000

# Systemd service
[Unit]
Description=Aura Protocol Backend
After=network.target

[Service]
User=www-data
WorkingDirectory=/var/www/aura-backend
ExecStart=/var/www/aura-backend/venv/bin/uvicorn server:app --host 0.0.0.0 --port 9000
Restart=always

[Install]
WantedBy=multi-user.target
```

### Smart Contract Deployment
```bash
cd contracts
npx hardhat run scripts/deploy.js --network polygon-amoy
```

---

## 📊 PROJECT TIMELINE

### Completed (Months 1-4)
- ✅ Wave 1: Foundation (2 months)
- ✅ Wave 2: Credit Passport (2 months)
- ✅ Deployment & Testing (ongoing)

### Planned (Months 5-12)
- 🔄 Wave 3: Expansion (5-6 months)
  - Cross-Chain Layer (2 months)
  - AI Risk Oracle (3 months)
  - Reputation DAO (3 months)

- 🔄 Wave 4: Monetization (6-7 months)
  - Payment Integration (2 months)
  - Enterprise Features (3 months)
  - Mobile App (4 months)
  - Advanced Analytics (1.5 months)

**Total Timeline:** 12-14 months for complete platform

---

## 🎯 SUCCESS METRICS

### Wave 1 & 2 (Current)
- ✅ Smart contracts deployed
- ✅ Frontend live & functional
- ✅ Backend API operational
- ✅ 5 badge types available
- ✅ Signature verification working
- ✅ Analytics dashboard live

### Wave 3 (Target)
- 🎯 6+ blockchain networks supported
- 🎯 AI risk model accuracy >85%
- 🎯 DAO with 1000+ token holders
- 🎯 Cross-chain badges functional

### Wave 4 (Target)
- 🎯 100+ paying customers
- 🎯 $5k+ MRR
- 🎯 Mobile app: 10k+ downloads
- 🎯 10+ enterprise clients

---

## 📞 CONTACT & RESOURCES

- **Live App:** https://www.aurapass.xyz
- **GitHub:** https://github.com/IdcuqS07/Aura-Protocol-V.1
- **Documentation:** See README.md
- **Support:** Create GitHub issue

---

**Last Updated:** November 1, 2025  
**Version:** 1.0  
**Status:** 🟢 Wave 1 & 2 Complete | Wave 3 & 4 Planned
