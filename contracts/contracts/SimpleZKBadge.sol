// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleZKBadge {
    uint256 private _tokenIds;
    
    struct Badge {
        uint256 id;
        address owner;
        string badgeType;
        string zkProofHash;
        uint256 issuedAt;
    }
    
    mapping(uint256 => Badge) public badges;
    mapping(address => uint256[]) public userBadges;
    
    event BadgeIssued(uint256 indexed tokenId, address indexed recipient, string badgeType);
    
    function issueBadge(
        address recipient,
        string memory badgeType,
        string memory zkProofHash
    ) external returns (uint256) {
        _tokenIds++;
        uint256 newTokenId = _tokenIds;
        
        badges[newTokenId] = Badge({
            id: newTokenId,
            owner: recipient,
            badgeType: badgeType,
            zkProofHash: zkProofHash,
            issuedAt: block.timestamp
        });
        
        userBadges[recipient].push(newTokenId);
        
        emit BadgeIssued(newTokenId, recipient, badgeType);
        
        return newTokenId;
    }
    
    function getUserBadges(address user) external view returns (uint256[] memory) {
        return userBadges[user];
    }
    
    function totalSupply() external view returns (uint256) {
        return _tokenIds;
    }
}