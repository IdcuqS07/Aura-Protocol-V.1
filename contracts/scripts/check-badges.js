const { ethers } = require("hardhat");

async function main() {
  const badgeAddress = "0xa297944E0A63aDB57730687d44aF6235aa8D0DA7";
  const userAddress = "0xb024196a8c1AB0b4960E2060Ceb4Ba32a43F2C29";

  const badge = await ethers.getContractAt("SimpleZKBadge", badgeAddress);
  const badges = await badge.getUserBadges(userAddress);
  
  console.log("User:", userAddress);
  console.log("Badge IDs:", badges.map(id => id.toString()));
  console.log("Total badges:", badges.length);
  
  for (let i = 0; i < badges.length; i++) {
    const badgeData = await badge.badges(badges[i]);
    console.log(`\nBadge #${badges[i]}:`);
    console.log("  Type:", badgeData.badgeType);
    console.log("  Proof:", badgeData.zkProofHash);
  }
}

main().catch(console.error);
