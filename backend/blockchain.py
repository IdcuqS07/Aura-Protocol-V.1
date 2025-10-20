from web3 import Web3
from eth_account import Account
import json
import os
from typing import Dict, Any, Optional
import logging

logger = logging.getLogger(__name__)

class PolygonIntegration:
    def __init__(self):
        # Polygon Mumbai testnet RPC
        self.rpc_url = "https://rpc-mumbai.maticvigil.com"
        self.w3 = Web3(Web3.HTTPProvider(self.rpc_url))
        
        # Contract addresses (will be updated after deployment)
        self.contracts = {
            "ZK_BADGE": "0x0000000000000000000000000000000000000000",
            "CIVIC_INTEGRATION": "0x0000000000000000000000000000000000000000",
            "WORLDCOIN_INTEGRATION": "0x0000000000000000000000000000000000000000"
        }
        
        # Load private key from environment
        self.private_key = os.getenv("POLYGON_PRIVATE_KEY")
        if self.private_key:
            self.account = Account.from_key(self.private_key)
        else:
            logger.warning("No private key found. Blockchain operations will be read-only.")
            self.account = None
    
    def load_contract_addresses(self, deployment_file: str = "deployment.json"):
        """Load contract addresses from deployment file"""
        try:
            with open(deployment_file, 'r') as f:
                deployment = json.load(f)
                self.contracts.update({
                    "ZK_BADGE": deployment["contracts"]["AuraZKBadge"],
                    "CIVIC_INTEGRATION": deployment["contracts"]["CivicIntegration"],
                    "WORLDCOIN_INTEGRATION": deployment["contracts"]["WorldcoinIntegration"]
                })
                logger.info("Contract addresses loaded successfully")
        except FileNotFoundError:
            logger.warning("Deployment file not found. Using default addresses.")
    
    def get_contract_abi(self, contract_name: str) -> list:
        """Get contract ABI (simplified for demo)"""
        # In production, load from compiled artifacts
        if contract_name == "ZK_BADGE":
            return [
                {
                    "inputs": [
                        {"name": "recipient", "type": "address"},
                        {"name": "badgeType", "type": "uint8"},
                        {"name": "zkProofHash", "type": "string"},
                        {"name": "metadataURI", "type": "string"}
                    ],
                    "name": "issueBadge",
                    "outputs": [{"name": "", "type": "uint256"}],
                    "type": "function"
                },
                {
                    "inputs": [
                        {"name": "user", "type": "address"},
                        {"name": "badgeType", "type": "uint8"}
                    ],
                    "name": "hasBadgeType",
                    "outputs": [{"name": "", "type": "bool"}],
                    "type": "function"
                }
            ]
        return []
    
    async def issue_zk_badge(
        self, 
        recipient: str, 
        badge_type: int, 
        zk_proof_hash: str, 
        metadata_uri: str
    ) -> Optional[str]:
        """Issue a ZK Badge on-chain"""
        if not self.account:
            logger.error("No account configured for blockchain operations")
            return None
        
        try:
            contract_address = self.contracts["ZK_BADGE"]
            contract_abi = self.get_contract_abi("ZK_BADGE")
            
            contract = self.w3.eth.contract(
                address=contract_address,
                abi=contract_abi
            )
            
            # Build transaction
            transaction = contract.functions.issueBadge(
                recipient,
                badge_type,
                zk_proof_hash,
                metadata_uri
            ).build_transaction({
                'from': self.account.address,
                'gas': 200000,
                'gasPrice': self.w3.to_wei('20', 'gwei'),
                'nonce': self.w3.eth.get_transaction_count(self.account.address)
            })
            
            # Sign and send transaction
            signed_txn = self.w3.eth.account.sign_transaction(transaction, self.private_key)
            tx_hash = self.w3.eth.send_raw_transaction(signed_txn.rawTransaction)
            
            logger.info(f"ZK Badge issued. Transaction hash: {tx_hash.hex()}")
            return tx_hash.hex()
            
        except Exception as e:
            logger.error(f"Error issuing ZK Badge: {str(e)}")
            return None
    
    async def verify_civic_proof(self, user_address: str, proof_hash: str) -> bool:
        """Verify Civic proof and issue badge"""
        try:
            # In production, this would interact with Civic's verification system
            # For demo, we'll simulate the verification
            
            metadata_uri = f"https://api.auraprotocol.com/metadata/civic/{proof_hash}"
            
            tx_hash = await self.issue_zk_badge(
                user_address,
                3,  # BadgeType.CIVIC
                proof_hash,
                metadata_uri
            )
            
            return tx_hash is not None
            
        except Exception as e:
            logger.error(f"Error verifying Civic proof: {str(e)}")
            return False
    
    async def verify_worldcoin_proof(
        self, 
        user_address: str, 
        nullifier_hash: str,
        proof: list
    ) -> bool:
        """Verify Worldcoin proof and issue badge"""
        try:
            # In production, this would verify the ZK proof with WorldID
            # For demo, we'll simulate the verification
            
            proof_hash = f"worldcoin_{nullifier_hash}"
            metadata_uri = f"https://api.auraprotocol.com/metadata/worldcoin/{nullifier_hash}"
            
            tx_hash = await self.issue_zk_badge(
                user_address,
                4,  # BadgeType.WORLDCOIN
                proof_hash,
                metadata_uri
            )
            
            return tx_hash is not None
            
        except Exception as e:
            logger.error(f"Error verifying Worldcoin proof: {str(e)}")
            return False
    
    async def check_user_badges(self, user_address: str) -> Dict[str, bool]:
        """Check which badge types a user has"""
        try:
            contract_address = self.contracts["ZK_BADGE"]
            contract_abi = self.get_contract_abi("ZK_BADGE")
            
            contract = self.w3.eth.contract(
                address=contract_address,
                abi=contract_abi
            )
            
            badge_types = {
                "uniqueness": 0,
                "identity": 1,
                "reputation": 2,
                "civic": 3,
                "worldcoin": 4
            }
            
            user_badges = {}
            for badge_name, badge_type in badge_types.items():
                has_badge = contract.functions.hasBadgeType(user_address, badge_type).call()
                user_badges[badge_name] = has_badge
            
            return user_badges
            
        except Exception as e:
            logger.error(f"Error checking user badges: {str(e)}")
            return {}

# Global instance
polygon_integration = PolygonIntegration()