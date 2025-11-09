# ⚡ QUICK OAUTH SETUP (5 MINUTES)

Sebelum deploy, Anda perlu setup 2 credentials ini:

---

## 1️⃣ GITHUB OAUTH (REQUIRED)

### Step 1: Buka GitHub Settings
```
https://github.com/settings/developers
```

### Step 2: Create New OAuth App
- Click: **"New OAuth App"**

### Step 3: Fill Form
```
Application name: Aura Protocol
Homepage URL: https://www.aurapass.xyz
Authorization callback URL: https://www.aurapass.xyz/api/poh/callback
```

### Step 4: Register & Copy Credentials
- Click **"Register application"**
- Copy **Client ID**
- Click **"Generate a new client secret"**
- Copy **Client Secret**

---

## 2️⃣ ALCHEMY API KEY (REQUIRED)

### Step 1: Sign Up/Login
```
https://www.alchemy.com/
```

### Step 2: Create New App
- Click **"Create new app"**

### Step 3: Configure
```
Name: Aura Protocol
Chain: Polygon
Network: Polygon Amoy (Testnet)
```

### Step 4: Copy API Key
- Click on your app
- Click **"View Key"**
- Copy **API Key**

---

## 3️⃣ UPDATE BACKEND .ENV

### Open .env file:
```bash
cd backend
nano .env
```

### Paste your credentials:
```env
# MongoDB
MONGO_URL=mongodb://localhost:27017
DB_NAME=aura_protocol

# OAuth - PASTE YOUR CREDENTIALS HERE
GITHUB_CLIENT_ID=Ov23li...your_client_id
GITHUB_CLIENT_SECRET=abc123...your_client_secret

# Blockchain - PASTE YOUR API KEY HERE
ALCHEMY_API_KEY=your_alchemy_api_key_here
PRIVATE_KEY=your_wallet_private_key_here

# CORS
CORS_ORIGINS=https://www.aurapass.xyz,http://localhost:3000

# Contracts (already deployed)
BADGE_CONTRACT_ADDRESS=0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678
PASSPORT_CONTRACT_ADDRESS=0x1112373c9954B9bbFd91eb21175699b609A1b551
PROOF_REGISTRY_ADDRESS=0x296DB144E62C8C826bffA4503Dc9Fbf29F25D44B
```

### Save:
- Press: `Ctrl + O`
- Press: `Enter`
- Press: `Ctrl + X`

---

## ✅ DONE!

Now run:
```bash
./DEPLOY_NOW.sh
```

---

## 📝 NOTES

- **GitHub OAuth**: Required for Proof of Humanity
- **Alchemy**: Required for on-chain data
- **Private Key**: Optional (only if you want backend to mint badges)
- **Twitter OAuth**: Optional (can skip for now)

---

## 🔒 SECURITY

- Never commit .env to git
- Keep credentials secure
- Use different keys for dev/prod

---

**Time**: 5 minutes  
**Difficulty**: Easy  
**Required**: GitHub + Alchemy only
