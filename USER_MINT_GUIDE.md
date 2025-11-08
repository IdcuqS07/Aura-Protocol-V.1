# 🎉 USER MINT CREDIT PASSPORT (DECENTRALIZED)

**Contract V2**: `0x1112373c9954B9bbFd91eb21175699b609A1b551`  
**Network**: Polygon Amoy Testnet  
**Status**: ✅ DEPLOYED

---

## ✅ KEPUTUSAN: USER MINT SENDIRI

### Kenapa User Mint?
- ✅ **Fully Decentralized** - No backend control
- ✅ **User Control** - User owns the process
- ✅ **Trustless** - No need to trust backend
- ✅ **Transparent** - All on-chain

### Trade-offs:
- ⚠️ User bayar gas (~0.007 MATIC)
- ⚠️ User perlu approve transaction
- ⚠️ Perlu wallet connection

---

## 🔧 CONTRACT FUNCTIONS

### 1. mintPassport() - User Mint Sendiri
```solidity
function mintPassport(
    uint256 pohScore,
    uint256 badgeCount
) external returns (uint256 tokenId)
```

**Siapa yang bisa call**: SIAPA SAJA (public)  
**Gas**: ~0.007 MATIC  
**Recipient**: msg.sender (otomatis untuk diri sendiri)

### 2. issuePassport() - Admin Mint (Optional)
```solidity
function issuePassport(
    address recipient,
    uint256 pohScore,
    uint256 badgeCount
) external onlyAuthorized returns (uint256 tokenId)
```

**Siapa yang bisa call**: Owner atau Authorized Minters  
**Use case**: Backup atau special cases

---

## 💻 FRONTEND INTEGRATION

### Install Dependencies
```bash
cd frontend
yarn add ethers@6
```

### Import Contract Utility
```javascript
import { mintPassport, getPassport, hasPassport } from './utils/passportContract';
```

### Check if User Has Passport
```javascript
const hasPP = await hasPassport(userAddress);
if (hasPP) {
  const passport = await getPassport(userAddress);
  console.log('Credit Score:', passport.creditScore);
}
```

### Mint Passport
```javascript
try {
  // Get user's PoH score and badge count from backend
  const pohScore = 75; // from PoH enrollment
  const badgeCount = 3; // from badges collection
  
  // User mints passport (pays gas)
  const { txHash, tokenId } = await mintPassport(pohScore, badgeCount);
  
  console.log('Passport minted!');
  console.log('TX:', txHash);
  console.log('Token ID:', tokenId);
} catch (error) {
  if (error.message.includes('Passport already exists')) {
    alert('You already have a passport!');
  } else {
    alert('Minting failed: ' + error.message);
  }
}
```

---

## 🎨 UI FLOW

### Step 1: Check Passport
```
User connects wallet
  ↓
Check if passport exists
  ↓
If YES → Show passport
If NO → Show "Mint Passport" button
```

### Step 2: Mint Passport
```
User clicks "Mint Passport"
  ↓
Fetch PoH score & badge count from backend
  ↓
Calculate estimated credit score
  ↓
Show preview: "Your score will be ~650"
  ↓
User confirms & signs transaction
  ↓
Wait for confirmation
  ↓
Show success & redirect to passport page
```

---

## 📊 SCORING LOGIC

### Backend API: Get User Data
```javascript
// GET /api/passport/score/{wallet_address}
const response = await fetch(`/api/passport/score/${address}`);
const data = await response.json();

// Returns:
{
  poh_score: 75,
  badge_count: 3,
  estimated_credit_score: 650
}
```

### Frontend: Mint with Data
```javascript
const { poh_score, badge_count } = data;
await mintPassport(poh_score, badge_count);
```

---

## 🔐 SECURITY

### Anti-Spam
- ✅ One passport per address (enforced by contract)
- ✅ Soulbound (cannot transfer)
- ✅ User pays gas (natural rate limit)

### Data Integrity
- ⚠️ User can input any pohScore/badgeCount
- ✅ Solution: Backend validates before showing mint button
- ✅ Only show mint if user completed PoH

---

## 🚀 DEPLOYMENT STEPS

### 1. Update Frontend
```bash
cd frontend
# Add passportContract.js utility
# Update CreditPassport.js component
git add .
git commit -m "Add user mint passport feature"
git push
```

### 2. Update Backend
```bash
cd backend
# Add /api/passport/score/{address} endpoint
# Returns user's PoH score & badge count
git add .
git commit -m "Add passport score endpoint"
git push
```

### 3. Deploy to VPS
```bash
ssh root@vps
cd /var/www/aura-frontend
git pull
yarn build
# Restart nginx

cd /var/www/aura-backend-new
git pull
/var/www/restart-backend.sh
```

---

## ✅ TESTING

### Test on Amoy Testnet
1. Connect wallet to Polygon Amoy
2. Get testnet MATIC from faucet
3. Complete PoH enrollment
4. Click "Mint Passport"
5. Approve transaction
6. Wait for confirmation
7. View passport

### Test Contract Directly
```bash
cd contracts
npx hardhat console --network amoy
```

```javascript
const contract = await ethers.getContractAt(
  "CreditPassport",
  "0x1112373c9954B9bbFd91eb21175699b609A1b551"
);

// Mint passport
const tx = await contract.mintPassport(75, 3);
await tx.wait();

// Get passport
const passport = await contract.getPassport(await signer.getAddress());
console.log('Credit Score:', passport.creditScore.toString());
```

---

## 📈 METRICS

### Track Minting
- Total passports minted
- Average credit score
- Gas spent per mint
- User adoption rate

### Monitor
```javascript
// Listen to PassportIssued events
contract.on('PassportIssued', (tokenId, owner, creditScore) => {
  console.log(`Passport #${tokenId} minted by ${owner}`);
  console.log(`Credit Score: ${creditScore}`);
});
```

---

## 🎉 BENEFITS

### For Users
- ✅ Full control over minting
- ✅ Transparent process
- ✅ No backend dependency
- ✅ Truly decentralized

### For Protocol
- ✅ No gas costs for backend
- ✅ Scalable (no backend bottleneck)
- ✅ Trustless reputation
- ✅ True Web3 spirit

---

## 📝 NEXT STEPS

1. ✅ Contract deployed
2. ⏳ Update frontend with mint UI
3. ⏳ Add backend score endpoint
4. ⏳ Test on testnet
5. ⏳ Deploy to production

---

**Contract**: `0x1112373c9954B9bbFd91eb21175699b609A1b551`  
**Explorer**: https://amoy.polygonscan.com/address/0x1112373c9954B9bbFd91eb21175699b609A1b551

**Aura Protocol - Truly Decentralized Credit Passport** ✨
