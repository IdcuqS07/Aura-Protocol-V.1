# 🔧 GitHub OAuth Fix - Step by Step

## ❌ Current Error
```
Be careful!
The redirect_uri is not associated with this application.
```

## ✅ Solution: Update GitHub OAuth App Settings

### Step 1: Go to GitHub OAuth Apps
1. Open: https://github.com/settings/developers
2. Click on **"OAuth Apps"** tab
3. Find your app (Client ID: `Ov23liBkJpXGppFuyWWV`)
4. Click on the app name to edit

### Step 2: Update Authorization Callback URL
Look for field: **"Authorization callback URL"**

**Current value** (wrong):
- Might be: `http://localhost:3000/poh/callback`
- Or: `https://aurapass.xyz/poh/callback`
- Or: Something else

**Change to** (correct):
```
https://www.aurapass.xyz/poh/callback
```

### Step 3: Important Rules
✅ **MUST** start with `https://` (not `http://`)
✅ **MUST** include `www.` (not just `aurapass.xyz`)
✅ **MUST** end with `/poh/callback` (no trailing slash)
✅ **MUST** be exactly: `https://www.aurapass.xyz/poh/callback`

❌ **WRONG** examples:
- `http://www.aurapass.xyz/poh/callback` (http not https)
- `https://aurapass.xyz/poh/callback` (missing www)
- `https://www.aurapass.xyz/poh/callback/` (trailing slash)
- `https://www.aurapass.xyz:443/poh/callback` (port number)

### Step 4: Save Changes
1. Click **"Update application"** button at bottom
2. Wait for confirmation message

### Step 5: Test
1. Go to: https://www.aurapass.xyz/verify
2. Click "Connect GitHub"
3. Should redirect to GitHub authorization page (no error)
4. After authorize, should redirect back to your site

## 🔍 Verification

After updating, the OAuth URL should be:
```
https://github.com/login/oauth/authorize?client_id=Ov23liBkJpXGppFuyWWV&redirect_uri=https%3A%2F%2Fwww.aurapass.xyz%2Fpoh%2Fcallback&scope=read:user
```

Notice: `redirect_uri=https%3A%2F%2Fwww.aurapass.xyz%2Fpoh%2Fcallback` (URL encoded)

## 📸 What to Check

If still error, send screenshot of:
1. GitHub OAuth App settings page showing "Authorization callback URL" field
2. Browser console when clicking "Connect GitHub"

## 🆘 Alternative: Create New OAuth App

If you can't find the existing app, create a new one:

1. Go to: https://github.com/settings/developers
2. Click "New OAuth App"
3. Fill in:
   - **Application name**: Aura Protocol
   - **Homepage URL**: https://www.aurapass.xyz
   - **Authorization callback URL**: `https://www.aurapass.xyz/poh/callback`
4. Click "Register application"
5. Copy the new **Client ID**
6. Generate a new **Client Secret**
7. Update `.env` files with new credentials

## 📝 Summary

The error means GitHub doesn't recognize the callback URL. This is 100% a GitHub settings issue, not a code issue. The code is already correct and hardcoded to `https://www.aurapass.xyz/poh/callback`.

**You MUST update the GitHub OAuth App settings to match this URL exactly.**
