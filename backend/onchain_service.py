import httpx
import os
from datetime import datetime

ALCHEMY_API_KEY = os.getenv("ALCHEMY_API_KEY", "")
ALCHEMY_BASE_URL = f"https://polygon-amoy.g.alchemy.com/v2/{ALCHEMY_API_KEY}"

async def get_onchain_data(wallet_address: str) -> dict:
    """Fetch on-chain data and calculate score"""
    async with httpx.AsyncClient() as client:
        # Get transaction count
        tx_count_resp = await client.post(
            ALCHEMY_BASE_URL,
            json={
                "jsonrpc": "2.0",
                "method": "eth_getTransactionCount",
                "params": [wallet_address, "latest"],
                "id": 1
            }
        )
        tx_count = int(tx_count_resp.json().get("result", "0x0"), 16)
        
        # Get balance
        balance_resp = await client.post(
            ALCHEMY_BASE_URL,
            json={
                "jsonrpc": "2.0",
                "method": "eth_getBalance",
                "params": [wallet_address, "latest"],
                "id": 2
            }
        )
        balance_wei = int(balance_resp.json().get("result", "0x0"), 16)
        balance_matic = balance_wei / 10**18
        
        # Get token balances (ERC20)
        token_resp = await client.post(
            ALCHEMY_BASE_URL,
            json={
                "jsonrpc": "2.0",
                "method": "alchemy_getTokenBalances",
                "params": [wallet_address],
                "id": 3
            }
        )
        tokens = token_resp.json().get("result", {}).get("tokenBalances", [])
        token_count = len([t for t in tokens if int(t.get("tokenBalance", "0x0"), 16) > 0])
        
        # Calculate score (0-30 points)
        tx_score = min(tx_count / 10, 15)  # Max 15 pts for 100+ txs
        balance_score = min(balance_matic * 2, 10)  # Max 10 pts for 5+ MATIC
        token_score = min(token_count, 5)  # Max 5 pts for 5+ tokens
        
        score = int(tx_score + balance_score + token_score)
        
        return {
            "wallet_address": wallet_address,
            "transaction_count": tx_count,
            "balance_matic": round(balance_matic, 4),
            "token_count": token_count,
            "score": score,
            "verified": True
        }
