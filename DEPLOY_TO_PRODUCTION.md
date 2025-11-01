# 🚀 Deploy to Production (aurapass.xyz)

## ✅ Build Completed

Production build sudah siap di folder `frontend/build/`

---

## 📦 Contract Addresses Updated

**New Contracts (Polygon Amoy):**
- SimpleZKBadge: `0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678`
- ProofRegistry: `0x296DB144E62C8C826bffA4503Dc9Fbf29F25D44B`
- Deployer: `0xC3EcE9AC328CB232dDB0BC677d2e980a1a3D3974`

---

## 🔄 Deployment Options

### Option 1: Push ke GitHub (Recommended)

```bash
# Add remote repository
git remote add origin https://github.com/YOUR_USERNAME/Aura-Protocol-V.1.git

# Push ke GitHub
git push -u origin main --force

# Vercel akan auto-deploy dari GitHub
```

### Option 2: Deploy via Vercel CLI

```bash
# Install Vercel CLI
npm i -g vercel

# Login
vercel login

# Deploy
cd frontend
vercel --prod
```

### Option 3: Manual Upload ke Vercel

1. Buka https://vercel.com/dashboard
2. Import project dari GitHub
3. Atau upload folder `frontend/build/` manual

---

## ⚙️ Vercel Environment Variables

Pastikan set di Vercel Dashboard:

```
REACT_APP_BACKEND_URL=https://aura-protocol-backend.vercel.app
GENERATE_SOURCEMAP=false
```

---

## 🔗 Production URLs

- **Frontend:** https://www.aurapass.xyz
- **Backend:** https://aura-protocol-backend.vercel.app
- **Contracts:** https://amoy.polygonscan.com/address/0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678

---

## ✅ After Deployment

1. Clear browser cache
2. Test wallet connection
3. Test badge minting
4. Verify contract addresses di dashboard

---

## 📝 Current Status

- ✅ Contracts deployed to Polygon Amoy
- ✅ Frontend built for production
- ✅ Contract addresses updated
- ⏳ Waiting for push to GitHub/Vercel

**Next:** Push ke GitHub atau deploy via Vercel CLI
