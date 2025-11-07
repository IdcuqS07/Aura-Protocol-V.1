# 🎯 Badge Minting Guide

## Overview

Aura Protocol mendukung **2 metode minting** untuk ZK-ID Badges:

1. **User-Controlled Minting** ⚡ - User bayar gas sendiri (RECOMMENDED)
2. **Backend-Controlled Minting** 🔧 - Backend bayar gas (Fallback)

---

## 🔥 Method 1: User-Controlled Minting (RECOMMENDED)

### Keuntungan:
- ✅ **Fully Decentralized** - Tidak ada backend yang kontrol
- ✅ **Permissionless** - User langsung mint tanpa backend
- ✅ **Transparent** - User lihat gas fee sebelum mint
- ✅ **No Backend Cost** - Protocol tidak perlu top-up wallet
- ✅ **Faster** - Tidak perlu API call ke backend

### Cara Kerja:
1. User connect wallet (MetaMask)
2. User klik "Mint Badge"
3. MetaMask popup muncul dengan gas estimate
4. User approve transaction
5. Badge langsung minted on-chain

### Requirements:
- User wallet harus punya MATIC untuk gas (~0.001 MATIC)
- User wallet harus di-authorize sebagai minter di contract

### Code Example:
```javascript
import { mintBadgeUserPays } from '@/utils/badgeMinting';

const result = await mintBadgeUserPays('uniqueness', '0xproof123');

if (result.success) {
  console.log('Minted!', result.txHash);
  console.log('Gas paid:', result.gasFee); // e.g. "0.0012 MATIC"
}
```

---

## 🔧 Method 2: Backend-Controlled Minting (Fallback)

### Keuntungan:
- ✅ **User tidak perlu MATIC** - Backend bayar gas
- ✅ **Onboarding mudah** - User baru tidak perlu beli MATIC dulu
- ✅ **Controlled** - Backend bisa validasi sebelum mint

### Kekurangan:
- ❌ **Backend cost** - Protocol harus top-up wallet backend
- ❌ **Centralized** - Backend kontrol minting
- ❌ **Slower** - Perlu API call + backend processing

### Cara Kerja:
1. User connect wallet
2. User sign message untuk verifikasi
3. Frontend kirim request ke backend API
4. Backend verify signature
5. Backend mint badge menggunakan deployer wallet
6. Backend return tx_hash ke frontend

### Requirements:
- Backend wallet (`POLYGON_PRIVATE_KEY`) harus punya MATIC
- Backend wallet harus owner atau authorized minter

### Code Example:
```javascript
import { mintBadgeBackendPays } from '@/utils/badgeMinting';

const result = await mintBadgeBackendPays('uniqueness', '0xproof123');

if (result.success) {
  console.log('Minted!', result.txHash);
  console.log('Gas paid by protocol');
}
```

---

## 🤖 Smart Minting (Auto-Select)

Sistem otomatis pilih metode terbaik:

```javascript
import { mintBadgeSmart } from '@/utils/badgeMinting';

// Auto-detect: User authorized? → User pays
//              User not authorized? → Backend pays
const result = await mintBadgeSmart('uniqueness', '0xproof123');
```

**Logic:**
1. Cek apakah user wallet adalah authorized minter
2. Jika YA → gunakan user-controlled minting
3. Jika TIDAK → gunakan backend-controlled minting

---

## 📊 Comparison

| Feature | User-Controlled | Backend-Controlled |
|---------|----------------|-------------------|
| **Gas Payment** | User pays | Backend pays |
| **Decentralization** | ✅ Fully | ❌ Centralized |
| **Speed** | ⚡ Fast | 🐢 Slower |
| **User Experience** | Need MATIC | No MATIC needed |
| **Backend Cost** | $0 | ~$0.001 per mint |
| **Authorization** | User must be minter | Backend is minter |

---

## 🔐 Authorization Setup

### Option A: Authorize User Wallets (For User-Controlled)

```solidity
// Contract owner calls this
function authorizeMinter(address minter) external onlyOwner
```

**Pros:**
- Users can mint directly
- No backend cost

**Cons:**
- Need to authorize each user
- Gas cost for authorization

### Option B: Backend as Sole Minter (For Backend-Controlled)

```solidity
// Only deployer wallet can mint
// No need to authorize anyone
```

**Pros:**
- Simple setup
- Controlled minting

**Cons:**
- Backend pays all gas
- Centralized

### Option C: Hybrid (RECOMMENDED)

```solidity
// Authorize backend wallet + selected users
authorizeMinter(backendWallet);
authorizeMinter(trustedUser1);
authorizeMinter(trustedUser2);
```

**Pros:**
- Flexibility
- Fallback to backend if user not authorized

---

## 🚀 Implementation Steps

### Step 1: Choose Your Strategy

**For Early Stage (MVP):**
- Use **Backend-Controlled** only
- Simple, controlled, easy to debug

**For Production:**
- Use **Smart Minting** (hybrid)
- User-controlled for authorized users
- Backend fallback for new users

### Step 2: Setup Contract Authorization

```bash
# Connect to contract
npx hardhat console --network amoy

# Authorize backend wallet
const badge = await ethers.getContractAt("SimpleZKBadge", "0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678");
await badge.authorizeMinter("0xBackendWalletAddress");
```

### Step 3: Update Frontend

```javascript
// In your component
import MintBadgeButton from '@/components/MintBadgeButton';

<MintBadgeButton
  badgeType="uniqueness"
  zkProofHash={proofHash}
  onSuccess={(result) => {
    console.log('Minted!', result);
    // Refresh badges
  }}
/>
```

### Step 4: Test Both Methods

```bash
# Test user-controlled (if authorized)
# → MetaMask popup appears
# → User pays gas

# Test backend-controlled (if not authorized)
# → Backend API called
# → Backend pays gas
```

---

## 💰 Gas Cost Estimation

### Polygon Amoy (Testnet):
- Gas Limit: ~200,000
- Gas Price: ~30 gwei
- **Cost per mint: ~0.006 MATIC** (~$0.005 USD)

### Polygon Mainnet:
- Gas Limit: ~200,000
- Gas Price: ~50 gwei
- **Cost per mint: ~0.01 MATIC** (~$0.008 USD)

### Monthly Cost (1000 mints):
- User-controlled: **$0** (users pay)
- Backend-controlled: **~$8** (backend pays)

---

## 🎯 Recommendation

### For Aura Protocol:

**Use User-Controlled Minting (Trustless Approach):**

1. **Authorize ALL users** as minters (permissionless)
2. **Users pay gas themselves** (~0.001 MATIC)
3. **Backend as fallback** only (for users without MATIC)
4. **Fully decentralized** - align with "Trustless World" vision

**Why?**
- ✅ **Fully Decentralized** - No backend control
- ✅ **Trustless** - Users don't need to trust backend
- ✅ **Permissionless** - Anyone can mint
- ✅ **Zero Backend Cost** - Users pay their own gas
- ✅ **Align with Vision** - "Universal Trust in a Trustless World"

---

## 📝 Environment Variables

### Backend `.env`:
```bash
# Required for backend-controlled minting
POLYGON_PRIVATE_KEY="0xYourDeployerPrivateKey"
```

### Frontend `.env`:
```bash
# Required for both methods
REACT_APP_BACKEND_URL="http://localhost:9000"
```

---

## 🧪 Testing Checklist

- [ ] Backend wallet has MATIC (check balance)
- [ ] Backend wallet is authorized minter (check contract)
- [ ] Frontend can connect to MetaMask
- [ ] Backend API `/badges/mint` works
- [ ] User can mint via backend (signature verification)
- [ ] Transaction appears on PolygonScan
- [ ] Badge appears in user's wallet
- [ ] Gas fee is tracked correctly

---

## 🔗 Resources

- **Contract Address**: `0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678`
- **Network**: Polygon Amoy Testnet
- **Explorer**: https://amoy.polygonscan.com/
- **RPC**: https://rpc-amoy.polygon.technology

---

**Last Updated**: January 2025  
**Status**: ✅ Ready for Production
