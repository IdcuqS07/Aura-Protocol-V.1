#!/bin/bash

echo "🔐 OAUTH CREDENTIALS SETUP GUIDE"
echo "=================================="
echo ""

cat << 'EOF'
Before deploying for user testing, you need to setup OAuth credentials.

📋 STEP-BY-STEP GUIDE:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1️⃣  GITHUB OAUTH APP
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Go to: https://github.com/settings/developers
2. Click "New OAuth App"
3. Fill in:
   - Application name: Aura Protocol
   - Homepage URL: https://www.aurapass.xyz
   - Authorization callback URL: https://www.aurapass.xyz/api/poh/callback
4. Click "Register application"
5. Copy "Client ID" and "Client Secret"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
2️⃣  TWITTER OAUTH APP (Optional for now)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Go to: https://developer.twitter.com/en/portal/dashboard
2. Create a new project and app
3. Enable OAuth 2.0
4. Add callback URL: https://www.aurapass.xyz/api/poh/callback
5. Copy "Client ID" and "Client Secret"

Note: Twitter OAuth is optional. You can skip this for initial testing.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
3️⃣  ALCHEMY API KEY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Go to: https://www.alchemy.com/
2. Sign up / Log in
3. Create a new app
4. Select "Polygon Amoy" network
5. Copy API Key

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
4️⃣  UPDATE BACKEND .ENV
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

After getting credentials, update backend/.env:

GITHUB_CLIENT_ID=your_github_client_id_here
GITHUB_CLIENT_SECRET=your_github_client_secret_here
TWITTER_CLIENT_ID=your_twitter_client_id_here (optional)
TWITTER_CLIENT_SECRET=your_twitter_client_secret_here (optional)
ALCHEMY_API_KEY=your_alchemy_api_key_here

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
5️⃣  DEPLOY TO VPS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

After updating .env locally:

1. SSH to VPS:
   ssh root@103.127.132.132

2. Update .env on VPS:
   nano /root/Aura-Protocol-V.1-main/backend/.env

3. Paste your credentials

4. Restart backend:
   systemctl restart aura-backend

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ VERIFICATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Test OAuth flow:
1. Visit: https://www.aurapass.xyz/verify
2. Click "Connect GitHub"
3. Authorize the app
4. Should redirect back with success

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 TEMPLATE .ENV FILE:

# MongoDB
MONGO_URL=mongodb://localhost:27017
DB_NAME=aura_protocol

# OAuth - REPLACE WITH YOUR CREDENTIALS
GITHUB_CLIENT_ID=Ov23li...
GITHUB_CLIENT_SECRET=abc123...
TWITTER_CLIENT_ID=xyz789... (optional)
TWITTER_CLIENT_SECRET=def456... (optional)

# Blockchain
ALCHEMY_API_KEY=your_alchemy_key
PRIVATE_KEY=your_wallet_private_key

# CORS
CORS_ORIGINS=https://www.aurapass.xyz,http://localhost:3000

# Contracts
BADGE_CONTRACT_ADDRESS=0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678
PASSPORT_CONTRACT_ADDRESS=0x1112373c9954B9bbFd91eb21175699b609A1b551
PROOF_REGISTRY_ADDRESS=0x296DB144E62C8C826bffA4503Dc9Fbf29F25D44B

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  SECURITY NOTES:
- Never commit .env to git
- Keep credentials secure
- Rotate keys regularly
- Use different keys for dev/prod

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

echo ""
echo "Do you want to edit backend/.env now? (y/n)"
read -r response

if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    nano backend/.env
    echo "✅ .env file updated"
else
    echo "ℹ️  You can edit it later: nano backend/.env"
fi

echo ""
echo "Ready to deploy? Run: ./deploy-for-testing.sh"
echo ""
