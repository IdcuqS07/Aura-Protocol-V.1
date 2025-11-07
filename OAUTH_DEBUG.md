# OAuth Debugging Guide

## Current Issue
GitHub OAuth redirect_uri mismatch error

## Checklist

### 1. GitHub OAuth App Settings
- [ ] Go to: https://github.com/settings/developers
- [ ] Click on your OAuth App
- [ ] Check "Authorization callback URL"
- [ ] Should be EXACTLY one of these:
  - `https://www.aurapass.xyz/poh/callback`
  - `https://aurapass.xyz/poh/callback`

### 2. Check Frontend .env
```bash
cd /var/www/aura-frontend
cat .env
```
Should contain:
```
REACT_APP_GITHUB_CLIENT_ID=Ov23liBkJpXGppFuyWWV
```

### 3. Test OAuth URL
Open browser console and run:
```javascript
console.log('Origin:', window.location.origin);
console.log('Callback URL:', window.location.origin + '/poh/callback');
```

### 4. Manual Test
Try this URL directly (replace CLIENT_ID):
```
https://github.com/login/oauth/authorize?client_id=Ov23liBkJpXGppFuyWWV&redirect_uri=https://www.aurapass.xyz/poh/callback&scope=read:user
```

## Common Issues

### Issue 1: www vs non-www
- User accesses: `https://aurapass.xyz/verify`
- Code generates: `https://aurapass.xyz/poh/callback`
- GitHub expects: `https://www.aurapass.xyz/poh/callback`
- **Solution**: Add BOTH URLs to GitHub OAuth App

### Issue 2: Trailing Slash
- Wrong: `https://www.aurapass.xyz/poh/callback/`
- Right: `https://www.aurapass.xyz/poh/callback`

### Issue 3: Port Number
- Wrong: `https://www.aurapass.xyz:443/poh/callback`
- Right: `https://www.aurapass.xyz/poh/callback`

### Issue 4: Protocol
- Wrong: `http://www.aurapass.xyz/poh/callback`
- Right: `https://www.aurapass.xyz/poh/callback`

## Quick Fix

If still not working, hardcode the callback URL:

```javascript
// In ProofOfHumanity.js
const handleGithubAuth = () => {
  const redirectUri = 'https://www.aurapass.xyz/poh/callback';
  window.location.href = `https://github.com/login/oauth/authorize?client_id=${GITHUB_CLIENT_ID}&redirect_uri=${encodeURIComponent(redirectUri)}&scope=read:user`;
};
```

Then add nginx redirect to force www:
```nginx
server {
    listen 443 ssl;
    server_name aurapass.xyz;
    return 301 https://www.aurapass.xyz$request_uri;
}
```
