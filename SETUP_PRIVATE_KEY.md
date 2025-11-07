# 🔑 Setup Private Key for On-Chain Minting

## Prerequisites

1. **Wallet dengan MATIC di Polygon Amoy testnet**
2. **Private key dari wallet tersebut**

## Step 1: Get Testnet MATIC

Dapatkan testnet MATIC dari faucet:
- https://faucet.polygon.technology/
- Pilih "Polygon Amoy"
- Paste wallet address kamu
- Request 0.5 MATIC (cukup untuk ~100 transactions)

## Step 2: Export Private Key

### Dari MetaMask:
1. Buka MetaMask
2. Klik 3 dots → Account details
3. Klik "Show private key"
4. Enter password
5. Copy private key (64 karakter hex)

### Dari Hardhat:
```bash
cd contracts
npx hardhat accounts
# Copy private key dari account pertama
```

## Step 3: Update .env di VPS

```bash
ssh root@159.65.134.137
nano /var/www/aura-backend-new/.env
```

Tambahkan/update line ini:
```
POLYGON_PRIVATE_KEY=your_64_character_hex_private_key_here
```

**⚠️ PENTING:**
- Jangan tambahkan `0x` prefix
- Harus 64 karakter hex (0-9, a-f)
- Jangan ada quotes atau spaces
- Jangan commit ke GitHub!

## Step 4: Restart Backend

```bash
/var/www/restart-backend.sh
```

## Step 5: Verify Setup

Check logs untuk confirm private key loaded:
```bash
ssh root@159.65.134.137
pm2 logs aura-backend --lines 20
```

Harusnya TIDAK ada warning:
```
No private key found. Blockchain operations will be read-only.
```

## Step 6: Test Minting

Run test script:
```bash
cd backend
python3 test_poh_full_flow.py
```

Expected output:
```
✅ Badge issued successfully!
   TX Hash: 0x123abc...
   PolygonScan: https://amoy.polygonscan.com/tx/0x123abc...
```

## Troubleshooting

### Error: "No account configured for minting"
- Private key tidak di-load
- Check .env file format
- Restart backend

### Error: "insufficient funds for gas"
- Wallet tidak punya MATIC
- Request dari faucet
- Wait 5 minutes dan retry

### Error: "Transaction failed"
- Contract address salah
- Contract tidak deployed
- Check contract di PolygonScan

### Error: "nonce too low"
- Transaction stuck
- Reset nonce di MetaMask
- Wait dan retry

## Security Notes

1. **NEVER commit private key to GitHub**
2. **Use separate wallet for testnet**
3. **Don't use mainnet wallet for testing**
4. **Rotate keys regularly**
5. **Monitor wallet balance**

## Contract Addresses

Current deployed contracts on Polygon Amoy:
- **SimpleZKBadge**: `0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678`
- **ProofRegistry**: `0xE380607e7f5516E3b0dd593cE89F79D6acEfC037`

Verify on PolygonScan:
- https://amoy.polygonscan.com/address/0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678

## Next Steps

After successful setup:
1. ✅ Test full PoH flow
2. ✅ Setup GitHub OAuth
3. ✅ Setup Twitter OAuth
4. ✅ Test with real OAuth codes
5. ✅ Deploy to production

---

**Need help?** Check backend logs:
```bash
ssh root@159.65.134.137
pm2 logs aura-backend --lines 50
```
