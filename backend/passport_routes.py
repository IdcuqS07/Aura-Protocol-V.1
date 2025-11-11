"""
Credit Passport Routes
User-controlled minting: User mints NFT, backend stores data
"""

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import Optional
from datetime import datetime, timezone
import logging

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/passport", tags=["Credit Passport"])

_db = None

def set_db(db):
    global _db
    _db = db

# ============ MODELS ============

class CalculateScoreRequest(BaseModel):
    wallet_address: str

class StorePassportRequest(BaseModel):
    wallet_address: str
    tx_hash: str
    token_id: int
    encrypted_profile: str


# ============ ROUTES ============

@router.post("/calculate-score")
async def calculate_score(request: CalculateScoreRequest):
    """
    Calculate credit score before minting
    Returns score data for user to mint NFT
    """
    try:
        # Get PoH data
        poh_data = await _db.poh_enrollments.find_one({"wallet_address": request.wallet_address})
        poh_score = poh_data.get("uniqueness_score", 0) if poh_data else 0
        
        # Get badges count
        badges = await _db.badges.find({"wallet_address": request.wallet_address}).to_list(100)
        badge_count = len(badges)
        
        # Get on-chain activity from badges
        onchain_tx_count = 0
        for badge in badges:
            if badge.get("tx_hash"):
                onchain_tx_count += 1
        
        # Calculate score (0-1000)
        # PoH: 40% (400 points max)
        poh_points = int((poh_score / 100) * 400)
        
        # Badges: 30% (300 points max, 30 per badge, max 10 badges)
        badge_points = min(badge_count * 30, 300)
        
        # Activity: 30% (300 points max)
        activity_points = min(onchain_tx_count * 50, 300)
        
        credit_score = poh_points + badge_points + activity_points
        
        # Grade
        if credit_score >= 800:
            grade = "AAA"
        elif credit_score >= 700:
            grade = "AA"
        elif credit_score >= 600:
            grade = "A"
        elif credit_score >= 500:
            grade = "BBB"
        elif credit_score >= 400:
            grade = "BB"
        else:
            grade = "B"
        
        return {
            "success": True,
            "credit_score": credit_score,
            "grade": grade,
            "breakdown": {
                "poh_score": poh_score,
                "poh_points": poh_points,
                "badge_count": badge_count,
                "badge_points": badge_points,
                "onchain_tx_count": onchain_tx_count,
                "activity_points": activity_points
            }
        }
        
    except Exception as e:
        logger.error(f"Score calculation error: {str(e)}")
        raise HTTPException(500, detail=str(e))


@router.post("/store")
async def store_passport(request: StorePassportRequest):
    """
    Store passport data after user mints NFT
    Called after user successfully mints on-chain
    """
    try:
        # Check if already stored
        existing = await _db.credit_passports.find_one({"wallet_address": request.wallet_address})
        if existing:
            raise HTTPException(400, "Passport already exists")
        
        # Recalculate score
        score_data = await calculate_score(CalculateScoreRequest(wallet_address=request.wallet_address))
        
        # Store passport
        passport = {
            "wallet_address": request.wallet_address,
            "token_id": request.token_id,
            "tx_hash": request.tx_hash,
            "credit_score": score_data["credit_score"],
            "grade": score_data["grade"],
            "breakdown": score_data["breakdown"],
            "encrypted_profile": request.encrypted_profile,
            "created_at": datetime.now(timezone.utc).isoformat()
        }
        
        await _db.credit_passports.insert_one(passport)
        
        logger.info(f"Passport stored for {request.wallet_address} - Score: {score_data['credit_score']}")
        
        return {
            "success": True,
            "message": "Passport stored successfully"
        }
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Store passport error: {str(e)}")
        raise HTTPException(500, detail=str(e))


@router.get("/{wallet_address}")
async def get_passport(wallet_address: str):
    """Get user's Credit Passport"""
    try:
        passport = await _db.credit_passports.find_one({"wallet_address": wallet_address})
        if not passport:
            raise HTTPException(404, "Passport not found")
        
        passport.pop("_id", None)
        
        return {
            "success": True,
            "passport": passport
        }
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Get passport error: {str(e)}")
        raise HTTPException(500, detail=str(e))
