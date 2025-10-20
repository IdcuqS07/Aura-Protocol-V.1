# Vercel Deployment Guide for Aura Protocol

## Prerequisites

1. **Vercel Account**: Sign up at [vercel.com](https://vercel.com)
2. **MongoDB Atlas**: Create a free cluster at [mongodb.com/cloud/atlas](https://www.mongodb.com/cloud/atlas)
3. **Git Repository**: Push your code to GitHub/GitLab/Bitbucket

## Step 1: Set Up MongoDB Atlas

1. Create a free MongoDB Atlas account
2. Create a new cluster
3. Create a database user with password
4. Whitelist all IP addresses (0.0.0.0/0) for Vercel
5. Get your connection string (should look like):
   ```
   mongodb+srv://username:password@cluster.mongodb.net/aura_protocol?retryWrites=true&w=majority
   ```

## Step 2: Prepare Environment Variables

You'll need to set these in Vercel dashboard:

```bash
# MongoDB Connection
MONGO_URL=mongodb+srv://username:password@cluster.mongodb.net/
DB_NAME=aura_protocol

# CORS Origins
CORS_ORIGINS=https://your-domain.vercel.app

# Frontend
REACT_APP_BACKEND_URL=https://your-domain.vercel.app
```

## Step 3: Deploy to Vercel

### Option A: Deploy via Vercel CLI

1. Install Vercel CLI:
   ```bash
   npm i -g vercel
   ```

2. Login to Vercel:
   ```bash
   vercel login
   ```

3. Deploy from project root:
   ```bash
   vercel
   ```

4. Follow the prompts:
   - Set up and deploy? **Y**
   - Which scope? Select your account
   - Link to existing project? **N**
   - Project name? **aura-protocol**
   - In which directory is your code located? **./**

5. Set environment variables:
   ```bash
   vercel env add MONGO_URL
   vercel env add DB_NAME
   vercel env add CORS_ORIGINS
   vercel env add REACT_APP_BACKEND_URL
   ```

6. Deploy to production:
   ```bash
   vercel --prod
   ```

### Option B: Deploy via Vercel Dashboard

1. Go to [vercel.com/new](https://vercel.com/new)
2. Import your Git repository
3. Configure project:
   - **Framework Preset**: Other
   - **Root Directory**: ./
   - **Build Command**: `cd frontend && yarn install && yarn build`
   - **Output Directory**: `frontend/build`

4. Add Environment Variables in Settings:
   - `MONGO_URL`
   - `DB_NAME`
   - `CORS_ORIGINS`
   - `REACT_APP_BACKEND_URL`

5. Click **Deploy**

## Step 4: Update CORS After Deployment

After first deployment, you'll get a URL like `https://aura-protocol.vercel.app`

1. Update environment variable:
   ```
   CORS_ORIGINS=https://aura-protocol.vercel.app,https://aura-protocol-*.vercel.app
   REACT_APP_BACKEND_URL=https://aura-protocol.vercel.app
   ```

2. Redeploy:
   ```bash
   vercel --prod
   ```

## Step 5: Configure Custom Domain (Optional)

1. Go to your project settings in Vercel
2. Navigate to **Domains**
3. Add your custom domain
4. Update DNS records as instructed
5. Update `CORS_ORIGINS` and `REACT_APP_BACKEND_URL` with your custom domain

## Troubleshooting

### Backend API Not Working

- Check that `/api` routes are properly configured in `vercel.json`
- Verify MongoDB connection string is correct
- Check Vercel function logs in dashboard

### Frontend Not Loading

- Ensure `REACT_APP_BACKEND_URL` points to your Vercel domain
- Check that build completed successfully
- Verify `frontend/build` directory exists

### Database Connection Issues

- Verify MongoDB Atlas IP whitelist includes 0.0.0.0/0
- Check database user has correct permissions
- Test connection string locally first

### CORS Errors

- Update `CORS_ORIGINS` to include your Vercel domain
- Include both production and preview URLs
- Format: `https://domain1.com,https://domain2.com`

## Important Notes

1. **Free Tier Limits**: Vercel free tier has:
   - 100GB bandwidth/month
   - 100 hours serverless function execution
   - Suitable for development and small projects

2. **Cold Starts**: Serverless functions may have cold start delays (1-2 seconds)

3. **MongoDB Atlas**: Free tier includes:
   - 512MB storage
   - Shared cluster
   - Good for development/testing

4. **Environment Variables**: Always use production values for production deployment

5. **Continuous Deployment**: Vercel automatically deploys on git push to main branch

## Production Checklist

- [ ] MongoDB Atlas cluster created and configured
- [ ] Database user created with strong password
- [ ] IP whitelist configured (0.0.0.0/0)
- [ ] All environment variables set in Vercel
- [ ] Frontend builds successfully
- [ ] Backend API responds correctly
- [ ] CORS configured properly
- [ ] Custom domain configured (if applicable)
- [ ] Test all features in production

## Support

For issues:
- Vercel Documentation: [vercel.com/docs](https://vercel.com/docs)
- MongoDB Atlas Docs: [docs.mongodb.com](https://docs.mongodb.com)
- Check Vercel function logs for backend errors
- Check browser console for frontend errors
