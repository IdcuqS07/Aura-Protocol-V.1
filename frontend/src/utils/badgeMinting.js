import { ethers } from 'ethers';

const BADGE_CONTRACT_ADDRESS = '0x9e6343BB504Af8a39DB516d61c4Aa0aF36c54678';

const BADGE_ABI = [
  'function issueBadge(address recipient, string badgeType, string zkProofHash) returns (uint256)',
  'function getUserBadges(address user) view returns (uint256[])',
  'function badges(uint256 tokenId) view returns (uint256 id, address owner, string badgeType, string zkProofHash, uint256 issuedAt)',
  'function authorizedMinters(address minter) view returns (bool)',
  'event BadgeIssued(uint256 indexed tokenId, address indexed recipient, string badgeType)'
];

/**
 * USER-CONTROLLED MINTING (User pays gas)
 * User mints badge directly from frontend
 */
export async function mintBadgeUserPays(badgeType, zkProofHash) {
  try {
    if (!window.ethereum) {
      throw new Error('MetaMask not installed');
    }

    const provider = new ethers.BrowserProvider(window.ethereum);
    const signer = await provider.getSigner();
    const userAddress = await signer.getAddress();

    const contract = new ethers.Contract(BADGE_CONTRACT_ADDRESS, BADGE_ABI, signer);

    // Check if user is authorized minter
    const isAuthorized = await contract.authorizedMinters(userAddress);
    
    if (!isAuthorized) {
      throw new Error('Wallet not authorized to mint. Please use backend minting.');
    }

    // Estimate gas
    const gasEstimate = await contract.issueBadge.estimateGas(
      userAddress,
      badgeType,
      zkProofHash
    );

    // Mint badge (user pays gas)
    const tx = await contract.issueBadge(
      userAddress,
      badgeType,
      zkProofHash,
      {
        gasLimit: gasEstimate * 120n / 100n // 20% buffer
      }
    );

    console.log('Transaction sent:', tx.hash);

    // Wait for confirmation
    const receipt = await tx.wait();

    // Extract token ID from event
    const event = receipt.logs.find(log => {
      try {
        const parsed = contract.interface.parseLog(log);
        return parsed.name === 'BadgeIssued';
      } catch {
        return false;
      }
    });

    let tokenId = null;
    if (event) {
      const parsed = contract.interface.parseLog(event);
      tokenId = parsed.args.tokenId.toString();
    }

    const gasUsed = receipt.gasUsed.toString();
    const gasPrice = receipt.gasPrice || tx.gasPrice;
    const gasFee = ethers.formatEther(receipt.gasUsed * gasPrice);

    return {
      success: true,
      txHash: receipt.hash,
      tokenId,
      gasUsed,
      gasFee: `${gasFee} MATIC`,
      method: 'user-controlled'
    };

  } catch (error) {
    console.error('User minting error:', error);
    return {
      success: false,
      error: error.message,
      method: 'user-controlled'
    };
  }
}

/**
 * BACKEND-CONTROLLED MINTING (Backend pays gas)
 * Fallback when user is not authorized minter
 */
export async function mintBadgeBackendPays(badgeType, zkProofHash) {
  try {
    if (!window.ethereum) {
      throw new Error('MetaMask not installed');
    }

    const provider = new ethers.BrowserProvider(window.ethereum);
    const signer = await provider.getSigner();
    const walletAddress = await signer.getAddress();

    // Sign message for verification
    const message = `Mint badge for ${walletAddress}`;
    const signature = await signer.signMessage(message);

    // Call backend API
    const response = await fetch(`${process.env.REACT_APP_BACKEND_URL}/api/badges/mint`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        wallet_address: walletAddress,
        badge_type: badgeType,
        zk_proof_hash: zkProofHash,
        message,
        signature
      })
    });

    const result = await response.json();

    if (result.success) {
      return {
        success: true,
        txHash: result.tx_hash,
        tokenId: result.token_id,
        gasUsed: result.gas_used,
        gasFee: result.gas_fee ? `${result.gas_fee} MATIC` : 'Paid by protocol',
        method: 'backend-controlled'
      };
    } else {
      throw new Error(result.message || 'Backend minting failed');
    }

  } catch (error) {
    console.error('Backend minting error:', error);
    return {
      success: false,
      error: error.message,
      method: 'backend-controlled'
    };
  }
}

/**
 * SMART MINTING (Auto-select best method)
 * Try user minting first, fallback to backend
 */
export async function mintBadgeSmart(badgeType, zkProofHash) {
  try {
    // Check if user is authorized minter
    const provider = new ethers.BrowserProvider(window.ethereum);
    const signer = await provider.getSigner();
    const userAddress = await signer.getAddress();

    const contract = new ethers.Contract(BADGE_CONTRACT_ADDRESS, BADGE_ABI, provider);
    const isAuthorized = await contract.authorizedMinters(userAddress);

    if (isAuthorized) {
      console.log('User is authorized minter, using user-controlled minting');
      return await mintBadgeUserPays(badgeType, zkProofHash);
    } else {
      console.log('User not authorized, using backend-controlled minting');
      return await mintBadgeBackendPays(badgeType, zkProofHash);
    }

  } catch (error) {
    console.error('Smart minting error:', error);
    // Fallback to backend
    return await mintBadgeBackendPays(badgeType, zkProofHash);
  }
}

/**
 * Get user badges from contract
 */
export async function getUserBadges(userAddress) {
  try {
    const provider = new ethers.BrowserProvider(window.ethereum);
    const contract = new ethers.Contract(BADGE_CONTRACT_ADDRESS, BADGE_ABI, provider);
    
    const badgeIds = await contract.getUserBadges(userAddress);
    
    const badges = [];
    for (const id of badgeIds) {
      const badge = await contract.badges(id);
      badges.push({
        id: badge.id.toString(),
        owner: badge.owner,
        badgeType: badge.badgeType,
        zkProofHash: badge.zkProofHash,
        issuedAt: new Date(Number(badge.issuedAt) * 1000).toISOString()
      });
    }
    
    return badges;
  } catch (error) {
    console.error('Error fetching badges:', error);
    return [];
  }
}

/**
 * Check if user is authorized minter
 */
export async function checkMinterStatus(userAddress) {
  try {
    const provider = new ethers.BrowserProvider(window.ethereum);
    const contract = new ethers.Contract(BADGE_CONTRACT_ADDRESS, BADGE_ABI, provider);
    
    const isAuthorized = await contract.authorizedMinters(userAddress);
    
    return {
      isAuthorized,
      canMintDirectly: isAuthorized,
      needsBackend: !isAuthorized
    };
  } catch (error) {
    console.error('Error checking minter status:', error);
    return {
      isAuthorized: false,
      canMintDirectly: false,
      needsBackend: true
    };
  }
}
