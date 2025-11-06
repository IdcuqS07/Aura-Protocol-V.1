import httpx
import os
from datetime import datetime

TWITTER_CLIENT_ID = os.getenv("TWITTER_CLIENT_ID", "")
TWITTER_CLIENT_SECRET = os.getenv("TWITTER_CLIENT_SECRET", "")
TWITTER_BEARER_TOKEN = os.getenv("TWITTER_BEARER_TOKEN", "")

async def exchange_code_for_token(code: str, redirect_uri: str) -> str:
    """Exchange OAuth code for access token"""
    async with httpx.AsyncClient() as client:
        response = await client.post(
            "https://api.twitter.com/2/oauth2/token",
            auth=(TWITTER_CLIENT_ID, TWITTER_CLIENT_SECRET),
            data={
                "code": code,
                "grant_type": "authorization_code",
                "redirect_uri": redirect_uri,
                "code_verifier": "challenge"
            }
        )
        data = response.json()
        return data.get("access_token")

async def get_twitter_data(access_token: str) -> dict:
    """Fetch Twitter user data and calculate score"""
    headers = {"Authorization": f"Bearer {access_token}"}
    
    async with httpx.AsyncClient() as client:
        # Get user profile
        response = await client.get(
            "https://api.twitter.com/2/users/me",
            headers=headers,
            params={"user.fields": "created_at,public_metrics"}
        )
        data = response.json()
        user = data.get("data", {})
        
        # Calculate score (0-30 points)
        created_at = datetime.fromisoformat(user.get('created_at', '').replace('Z', '+00:00'))
        account_age_days = (datetime.now() - created_at).days
        metrics = user.get('public_metrics', {})
        
        age_score = min(account_age_days / 365 * 10, 10)  # Max 10 pts for 1+ year
        follower_score = min(metrics.get('followers_count', 0) / 100, 10)  # Max 10 pts for 1000+ followers
        tweet_score = min(metrics.get('tweet_count', 0) / 100, 10)  # Max 10 pts for 1000+ tweets
        
        score = int(age_score + follower_score + tweet_score)
        
        return {
            "username": user.get('username'),
            "account_age_days": account_age_days,
            "followers": metrics.get('followers_count', 0),
            "tweets": metrics.get('tweet_count', 0),
            "score": score,
            "verified": True
        }
