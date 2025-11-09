# Test Passport Minting di Localhost

## 1. Start Services

**Terminal 1 - Backend:**
```bash
cd backend
source venv/bin/activate
uvicorn server:app --reload --host 0.0.0.0 --port 9000
```

**Terminal 2 - Frontend:**
```bash
cd frontend
yarn start
```

Atau gunakan script:
```bash
./START_LOCAL.sh
```

## 2. Akses Aplikasi

- Frontend: http://localhost:3000
- Backend: http://localhost:9000
- API Docs: http://localhost:9000/docs

## 3. Test Passport Minting

1. **Buka**: http://localhost:3000/passport
2. **Connect Wallet**: MetaMask (Polygon Amoy)
3. **Klik**: "Mint Passport (Pay Gas)"
4. **Lihat**: Popup konfirmasi dengan:
   - PoH Score: (dari backend)
   - Badges: (jumlah badge)
   - Estimated Credit Score: (calculated)
   - Gas fee: ~0.007 MATIC

5. **Confirm**: Klik OK
6. **MetaMask**: Approve transaction
7. **Wait**: Transaction confirmed
8. **Success**: Passport minted!

## 4. Debug Console

Buka browser console (F12) untuk melihat:
- API calls ke `/api/passport/score/{address}`
- Response data
- Error messages (jika ada)

## 5. Test Backend Endpoint

```bash
# Test dengan wallet address kamu
curl http://localhost:9000/api/passport/score/0xYourAddress | python3 -m json.tool
```

Expected response:
```json
{
  "success": true,
  "user_id": "0xYourAddress",
  "credit_score": 70,
  "grade": "Poor",
  "risk_level": "high",
  "breakdown": {
    "poh_score": 20,
    "badge_count": 50,
    "onchain_activity": 0,
    "reputation": 0
  },
  "user_data": {
    "poh_score": 5,
    "badge_count": 1,
    "onchain_activity": 0,
    "reputation": 0
  }
}
```

## 6. Troubleshooting

### Error: "Failed to fetch your data"
- Backend tidak running
- MongoDB tidak running
- User belum ada di database

**Fix:**
```bash
# Check backend
curl http://localhost:9000/api/health

# Check MongoDB
mongosh
> use aura_protocol
> db.users.find()
```

### Error: "Passport already exists"
- Wallet sudah punya passport
- Check on-chain: https://amoy.polygonscan.com/address/0x1112373c9954B9bbFd91eb21175699b609A1b551

### Error: MetaMask transaction failed
- Insufficient MATIC for gas
- Wrong network (harus Polygon Amoy)
- Contract error

**Fix:**
- Get testnet MATIC: https://faucet.polygon.technology/
- Switch network ke Polygon Amoy
- Check contract: 0x1112373c9954B9bbFd91eb21175699b609A1b551

## 7. Expected Flow

```
1. User clicks "Mint Passport"
   ↓
2. Frontend calls: GET /api/passport/score/{address}
   ↓
3. Backend returns: { user_data: { poh_score, badge_count }, credit_score }
   ↓
4. Frontend shows confirmation popup
   ↓
5. User confirms
   ↓
6. Frontend calls: mintPassport(poh_score, badge_count) [on-chain]
   ↓
7. MetaMask popup for transaction
   ↓
8. User approves
   ↓
9. Transaction sent to Polygon Amoy
   ↓
10. Wait for confirmation
    ↓
11. Frontend calls: POST /api/passport/create
    ↓
12. Backend saves to MongoDB
    ↓
13. Success! Passport minted
```

## 8. Verify Success

```bash
# Check MongoDB
mongosh
> use aura_protocol
> db.passports.find().pretty()

# Check on-chain
# Visit: https://amoy.polygonscan.com/address/0x1112373c9954B9bbFd91eb21175699b609A1b551
# Look for "Mint" transaction from your wallet
```

## 9. Test AI Risk Oracle

Setelah passport minted:
1. Scroll ke bawah ke "AI Risk Oracle" section
2. Klik "Generate AI Risk Assessment"
3. Lihat:
   - Risk Score (0-100)
   - Trust Score (0-100)
   - Confidence %
   - Risk Factors

## 10. Stop Services

```bash
# Ctrl+C di terminal backend
# Ctrl+C di terminal frontend

# Atau kill semua:
pkill -f "uvicorn server:app"
pkill -f "react-scripts start"
```

---

**Ready to test!** 🚀

Jalankan: `./START_LOCAL.sh` atau start manual di 2 terminal.
