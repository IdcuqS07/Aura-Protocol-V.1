"""
Test Credit Passport Routes
"""

import requests
import json

BASE_URL = "http://localhost:9000/api/passport"

# Test wallet address (from PoH)
WALLET_ADDRESS = "0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"

def test_calculate_score():
    """Test score calculation"""
    print("\n=== Test 1: Calculate Score ===")
    
    response = requests.post(
        f"{BASE_URL}/calculate-score",
        json={"wallet_address": WALLET_ADDRESS}
    )
    
    print(f"Status: {response.status_code}")
    data = response.json()
    print(json.dumps(data, indent=2))
    
    return data

def test_store_passport():
    """Test storing passport after mint"""
    print("\n=== Test 2: Store Passport ===")
    
    response = requests.post(
        f"{BASE_URL}/store",
        json={
            "wallet_address": WALLET_ADDRESS,
            "tx_hash": "0x1234567890abcdef",
            "token_id": 1,
            "encrypted_profile": "encrypted_data_here"
        }
    )
    
    print(f"Status: {response.status_code}")
    data = response.json()
    print(json.dumps(data, indent=2))

def test_get_passport():
    """Test getting passport"""
    print("\n=== Test 3: Get Passport ===")
    
    response = requests.get(f"{BASE_URL}/{WALLET_ADDRESS}")
    
    print(f"Status: {response.status_code}")
    data = response.json()
    print(json.dumps(data, indent=2))

if __name__ == "__main__":
    print("Testing Credit Passport Routes...")
    print(f"Wallet: {WALLET_ADDRESS}")
    
    # Test 1: Calculate score
    score_data = test_calculate_score()
    
    # Test 2: Store passport (comment out if already stored)
    # test_store_passport()
    
    # Test 3: Get passport
    # test_get_passport()
    
    print("\n✅ Tests complete!")
