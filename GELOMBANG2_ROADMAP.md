# 🌊 AURA PROTOCOL - GELOMBANG 2 ROADMAP

**Version**: 1.0 (FINAL - DO NOT CHANGE)  
**Date**: January 2025  
**Status**: In Progress

---

## 🎯 VISION ALIGNMENT

**Tagline**: "Polygon ZK-ID Credit Layer - Universal Trust in a Trustless World"

### Core Outputs:
1. ✅ ZK-ID Badge (Soulbound NFT)
2. 🔄 Credit Passport (Dynamic SBT)
3. 🔄 ZK Proofs (Verifiable Credentials)
4. 🔄 Proof-as-a-Service API
5. ⏳ AI Risk Oracle

---

## 📊 GELOMBANG STATUS

### ✅ GELOMBANG 1: Foundation (COMPLETE)
- ✅ Proof of Uniqueness
- ✅ ZK Identity Layer
- ✅ Civic & Worldcoin Integration (MOCK)
- ✅ ZK-ID Badge Launch (Soulbound NFT)
- ✅ Deployed on Polygon Amoy
- ✅ Live at: https://www.aurapass.xyz/

### 🔄 GELOMBANG 2: ZK Credit Passport (IN PROGRESS)

**Completed**:
- ✅ Credit Passport NFT concept
- ✅ Analytics Dashboard
- ✅ Premium Features
- ✅ Smart Contracts Deployed
- ✅ 6 Badge Types (1 real, 5 demo)

**In Progress**:
- 🔄 Proof of Humanity (PoH) - Real verification
- 🔄 Credit Passport implementation
- 🔄 Proof-as-a-Service API

**Pending**:
- ⏳ The Graph integration
- ⏳ AI Risk Oracle (basic ML)

### ⏳ GELOMBANG 3: Expansion (COMING SOON)
- 🔄 Cross-Chain Layer (AuraX)
- 🔄 AI Risk Oracle (advanced)
- 🔄 Reputation DAO
- 🔄 Multi-Chain Support

---

## 🚀 GELOMBANG 2 - DETAILED ROADMAP

### **PHASE 1: Proof of Humanity (PoH) Completion**
**Timeline**: 2-3 days  
**Priority**: CRITICAL

#### Tasks:
1. **OAuth Setup** (Kamu - 10%)
   - [ ] Create GitHub OAuth App
   - [ ] Create Twitter OAuth App
   - [ ] Get Alchemy API Key
   - [ ] Update `.env` files

2. **Backend Integration** (Saya - 90%)
   - [x] GitHub OAuth service (`github_service.py`)
   - [x] Twitter OAuth service (`twitter_service.py`)
   - [x] Alchemy on-chain service (`onchain_service.py`)
   - [x] PoH routes (`poh_routes.py`)
   - [x] Scoring algorithm (0-100 points)

3. **Frontend** (Saya - 90%)
   - [x] PoH component (`ProofOfHumanity.js`)
   - [x] 4-step enrollment flow
   - [x] OAuth redirect handling
   - [ ] Error handling & UX polish

4. **Testing** (Kamu - 10%)
   - [ ] Test GitHub OAuth flow
   - [ ] Test Twitter OAuth flow
   - [ ] Test on-chain data fetching
   - [ ] End-to-end PoH flow

5. **Deployment** (Kamu - 10%)
   - [ ] Push to GitHub
   - [ ] Deploy to VPS
   - [ ] Update production `.env`
   - [ ] Test on production

#### Output:
- ✅ Real verification via GitHub + Twitter + On-chain
- ✅ Uniqueness score (0-100)
- ✅ ZK proof generation
- ✅ Badge minting

---

### **PHASE 2: Credit Passport Implementation**
**Timeline**: 3-4 days  
**Priority**: HIGH

#### Tasks:
1. **Smart Contract** (Saya - 90%)
   - [ ] CreditPassport.sol (ERC-721 Soulbound)
   - [ ] Credit score storage (0-1000)
   - [ ] Badge aggregation
   - [ ] Update mechanism
   - [ ] Deploy to Polygon Amoy

2. **Scoring Algorithm** (Saya - 90%)
   - [ ] Aggregate all badges
   - [ ] PoH score weight (40%)
   - [ ] Badge count weight (30%)
   - [ ] On-chain activity weight (30%)
   - [ ] Calculate final score (0-1000)

3. **Backend** (Saya - 90%)
   - [ ] `/passport/create` endpoint
   - [ ] `/passport/update` endpoint
   - [ ] `/passport/score` endpoint
   - [ ] Score calculation service
   - [ ] MongoDB schema

4. **Frontend** (Saya - 90%)
   - [ ] Credit Passport page
   - [ ] Score visualization
   - [ ] Badge list display
   - [ ] Mint/Update buttons

5. **Testing & Deployment** (Kamu - 10%)
   - [ ] Test score calculation
   - [ ] Test passport minting
   - [ ] Deploy contract
   - [ ] Deploy backend/frontend

#### Output:
- ✅ Credit Passport NFT (Dynamic SBT)
- ✅ Credit Score (0-1000)
- ✅ Badge aggregation
- ✅ On-chain reputation

---

### **PHASE 3: Proof-as-a-Service API**
**Timeline**: 2-3 days  
**Priority**: HIGH

#### Tasks:
1. **Public API** (Saya - 90%)
   - [ ] `/api/v1/proof/generate` (public)
   - [ ] `/api/v1/proof/verify` (public)
   - [ ] `/api/v1/passport/query` (public)
   - [ ] API key authentication
   - [ ] Rate limiting (100/day free, 1000/day premium)

2. **API Key Management** (Saya - 90%)
   - [ ] Generate API keys
   - [ ] Store in MongoDB
   - [ ] Middleware for auth
   - [ ] Usage tracking

3. **Documentation** (Saya - 90%)
   - [ ] API docs (Swagger/OpenAPI)
   - [ ] Integration guide
   - [ ] Code examples (JS, Python)
   - [ ] Postman collection

4. **Frontend Dashboard** (Saya - 90%)
   - [ ] API key generation UI
   - [ ] Usage statistics
   - [ ] Request logs
   - [ ] Pricing tiers

5. **Testing** (Kamu - 10%)
   - [ ] Test API endpoints
   - [ ] Test rate limiting
   - [ ] Test authentication
   - [ ] Integration test with sample dApp

#### Output:
- ✅ Public Proof-as-a-Service API
- ✅ API key system
- ✅ Documentation
- ✅ Universal trust for dApps

---

### **PHASE 4: The Graph Integration** (Optional)
**Timeline**: 2-3 days  
**Priority**: MEDIUM

#### Tasks:
1. **Subgraph** (Saya - 90%)
   - [ ] Define schema (badges, passports, scores)
   - [ ] Write mappings
   - [ ] Deploy to The Graph
   - [ ] Test queries

2. **Backend Integration** (Saya - 90%)
   - [ ] GraphQL client
   - [ ] Query DeFi history
   - [ ] Aggregate on-chain data
   - [ ] Cache results

3. **Frontend** (Saya - 90%)
   - [ ] Display indexed data
   - [ ] Transaction history
   - [ ] Badge timeline

#### Output:
- ✅ DeFi history indexing
- ✅ Fast on-chain queries
- ✅ Historical data

---

### **PHASE 5: AI Risk Oracle (Basic)** (Optional)
**Timeline**: 3-4 days  
**Priority**: MEDIUM

#### Tasks:
1. **ML Model** (Saya - 90%, Kamu - 10% training)
   - [ ] Data collection (badges, scores, behavior)
   - [ ] Feature engineering
   - [ ] Train basic model (sklearn)
   - [ ] Export model (pickle/joblib)

2. **Backend** (Saya - 90%)
   - [ ] `/oracle/risk-score` endpoint
   - [ ] Load ML model
   - [ ] Inference service
   - [ ] Cache predictions

3. **Frontend** (Saya - 90%)
   - [ ] Risk score display
   - [ ] Risk level (Low/Medium/High)
   - [ ] Explanation

#### Output:
- ✅ AI-powered risk assessment
- ✅ ML-based scoring
- ✅ Risk oracle for lending protocols

---

## 📦 DELIVERABLES SUMMARY

### **End of Gelombang 2**:
1. ✅ **Proof of Humanity** - Real verification (GitHub + Twitter + On-chain)
2. ✅ **Credit Passport** - Dynamic SBT with credit score (0-1000)
3. ✅ **Proof-as-a-Service** - Public API for dApps
4. ✅ **The Graph** - DeFi history indexing (optional)
5. ✅ **AI Risk Oracle** - Basic ML scoring (optional)

### **Tech Stack**:
- **Frontend**: React, TailwindCSS, ethers.js
- **Backend**: FastAPI (Python), MongoDB
- **Blockchain**: Solidity, Hardhat, Polygon Amoy
- **APIs**: GitHub, Twitter, Alchemy, The Graph
- **ML**: scikit-learn (basic models)

---

## 🤝 TEAM RESPONSIBILITIES

### **Saya (90%)**:
- ✅ Write all code (backend, frontend, contracts)
- ✅ Design architecture
- ✅ Implement features
- ✅ Create deployment scripts
- ✅ Write documentation
- ✅ Debug & optimize

### **Kamu (10%)**:
- ✅ Setup OAuth credentials (GitHub, Twitter, Alchemy)
- ✅ Deploy to VPS (SSH + git pull + restart services)
- ✅ Test real transactions (wallet + gas)
- ✅ Manage production environment
- ✅ Train ML models (if needed)

---

## 📈 SUCCESS METRICS

### **Phase 1 (PoH)**:
- [ ] 100+ users enrolled
- [ ] 50+ real verifications
- [ ] Average score: 60+

### **Phase 2 (Credit Passport)**:
- [ ] 50+ passports minted
- [ ] Average credit score: 500+
- [ ] 10+ badges per user

### **Phase 3 (API)**:
- [ ] 10+ API keys issued
- [ ] 1000+ API calls
- [ ] 5+ dApp integrations

---

## 🔒 RULES

1. **DO NOT CHANGE** this roadmap without discussion
2. **FOLLOW** the phase order (1 → 2 → 3)
3. **COMPLETE** each phase before moving to next
4. **TEST** thoroughly before deployment
5. **DOCUMENT** all changes

---

## 📝 NOTES

- **Local Development**: Always test on localhost first
- **VPS Deployment**: Only deploy tested & working code
- **Database**: Separate local & production MongoDB
- **Smart Contracts**: Test on Amoy before mainnet
- **API Keys**: Never commit to GitHub

---

## 🎯 CURRENT FOCUS

**NOW**: Phase 1 - Complete PoH  
**NEXT**: Phase 2 - Credit Passport  
**THEN**: Phase 3 - Proof-as-a-Service

---

**Last Updated**: January 2025  
**Status**: 🔄 IN PROGRESS  
**Completion**: 30% (Gelombang 2)

---

> "Universal Trust in a Trustless World" - Aura Protocol
