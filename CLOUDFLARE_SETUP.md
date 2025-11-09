# Cloudflare Cache Purge Setup

## 📋 Get Credentials

### 1. Get Zone ID
1. Login to [Cloudflare Dashboard](https://dash.cloudflare.com)
2. Select domain **aurapass.xyz**
3. Scroll down on Overview page
4. Copy **Zone ID** from right sidebar

### 2. Create API Token
1. Click profile icon (top right) → **My Profile**
2. Go to **API Tokens** tab
3. Click **Create Token**
4. Use **Edit zone DNS** template OR create custom with:
   - Permissions: `Zone → Cache Purge → Purge`
   - Zone Resources: `Include → Specific zone → aurapass.xyz`
5. Click **Continue to summary** → **Create Token**
6. Copy the token (shown only once!)

## 🚀 Usage

### Set credentials (one-time):
```bash
export CF_ZONE_ID='your_zone_id_here'
export CF_API_TOKEN='your_api_token_here'
```

### Run purge:
```bash
./purge-cloudflare.sh
```

### Or add to .bashrc/.zshrc for permanent:
```bash
echo 'export CF_ZONE_ID="your_zone_id"' >> ~/.zshrc
echo 'export CF_API_TOKEN="your_api_token"' >> ~/.zshrc
source ~/.zshrc
```

## 🔄 Alternative: Manual Purge

1. Login to Cloudflare Dashboard
2. Select **aurapass.xyz**
3. Go to **Caching** → **Configuration**
4. Click **Purge Everything**
5. Confirm

## ✅ Verify

After purging, wait 30 seconds then test:
- https://www.aurapass.xyz/analytics
- Check browser DevTools → Network → Response headers
- `cf-cache-status` should be `MISS` or `DYNAMIC`

## 📝 Notes

- Cache purge takes ~30 seconds to propagate globally
- Purge entire cache after every frontend deployment
- API token is safer than Global API Key
- Keep credentials secure, never commit to Git
