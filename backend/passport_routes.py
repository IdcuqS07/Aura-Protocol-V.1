from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import Optional
from datetime import datetime, timezone
import uuid

router = APIRouter()

# Database reference (injected from server.py)
db = None

def set_db(database):
    global db
    db = database

# ============ MODELS ============

class CreatePassportRequest(BaseModel):
    user_id: str
    wallet_address: str

class UpdatePassportRequest(BaseModel):
    user_id: str

class CreatePassportFromWalletRequest(BaseModel):
    wallet_address: str
    poh_score: Optional[int] = 0

# ============ ROUTES ============

@router.post("/passport/create")
async def create_passport(request: CreatePassportRequest):
    """Create Credit Passport for user"""
    if not db:
        raise HTTPException(status_code=500, detail="Database not initialized")
    
    # Check if passport exists
    existing = await db.passports.find_one({"wallet_address": request.wallet_address})
    if existing:
        return {"success": False, "message": "Passport already exists"}
    
    # Get user data
    user = await db.users.find_one({"wallet_address": request.wallet_address})
    credit_score = user.get("credit_score", 0) if user else 0
    
    # Create passport
    passport_doc = {
        "id": str(uuid.uuid4()),
        "user_id": request.user_id,
        "wallet_address": request.wallet_address,
        "passport_id": f"PASS-{uuid.uuid4().hex[:12].upper()}",
        "credit_score": credit_score,
        "reputation_score": user.get("reputation_score", 0.0) if user else 0.0,
        "risk_level": "medium" if credit_score >= 600 else "high",
        "zk_proof_hash": f"0x{uuid.uuid4().hex}",
        "soulbound_token_id": f"SBT-{uuid.uuid4().hex[:10].upper()}",
        "created_at": datetime.now(timezone.utc).isoformat(),
        "last_updated": datetime.now(timezone.utc).isoformat()
    }
    
    await db.passports.insert_one(passport_doc)
    
    return {
        "success": True,
        "passport_id": passport_doc["passport_id"],
        "credit_score": credit_score
    }

@router.post("/passport/update")
async def update_passport(request: UpdatePassportRequest):
    """Update Credit Passport score"""
    if not db:
        raise HTTPException(status_code=500, detail="Database not initialized")
    
    passport = await db.passports.find_one({"user_id": request.user_id})
    if not passport:
        raise HTTPException(status_code=404, detail="Passport not found")
    
    # Recalculate score
    user = await db.users.find_one({"id": request.user_id})
    new_score = user.get("credit_score", 0) if user else 0
    
    await db.passports.update_one(
        {"user_id": request.user_id},
        {"$set": {
            "credit_score": new_score,
            "last_updated": datetime.now(timezone.utc).isoformat()
        }}
    )
    
    return {"success": True, "credit_score": new_score}

@router.get("/passport/score/{wallet_address}")
async def get_passport_score(wallet_address: str):
    """Get Credit Passport score by wallet"""
    if not db:
        raise HTTPException(status_code=500, detail="Database not initialized")
    
    passport = await db.passports.find_one({"wallet_address": wallet_address}, {"_id": 0})
    if not passport:
        return {"wallet_address": wallet_address, "credit_score": 0, "exists": False}
    
    return {
        "wallet_address": wallet_address,
        "credit_score": passport.get("credit_score", 0),
        "reputation_score": passport.get("reputation_score", 0.0),
        "risk_level": passport.get("risk_level", "unknown"),
        "exists": True
    }

@router.post("/passport/create-from-wallet")
async def create_passport_from_wallet(request: CreatePassportFromWalletRequest):
    """Create passport directly from wallet address"""
    if not db:
        raise HTTPException(status_code=500, detail="Database not initialized")
    
    # Check existing
    existing = await db.passports.find_one({"wallet_address": request.wallet_address})
    if existing:
        return {"success": False, "message": "Passport already exists"}
    
    # Calculate credit score from PoH
    credit_score = min(1000, int(request.poh_score * 10))
    
    passport_doc = {
        "id": str(uuid.uuid4()),
        "user_id": f"user_{uuid.uuid4().hex[:8]}",
        "wallet_address": request.wallet_address,
        "passport_id": f"PASS-{uuid.uuid4().hex[:12].upper()}",
        "credit_score": credit_score,
        "reputation_score": float(request.poh_score),
        "risk_level": "low" if credit_score >= 750 else "medium" if credit_score >= 600 else "high",
        "zk_proof_hash": f"0x{uuid.uuid4().hex}",
        "soulbound_token_id": f"SBT-{uuid.uuid4().hex[:10].upper()}",
        "created_at": datetime.now(timezone.utc).isoformat(),
        "last_updated": datetime.now(timezone.utc).isoformat()
    }
    
    await db.passports.insert_one(passport_doc)
    
    return {
        "success": True,
        "passport_id": passport_doc["passport_id"],
        "credit_score": credit_score
    }
