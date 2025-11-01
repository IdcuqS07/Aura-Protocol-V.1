const { ethers } = require("hardhat");

async function main() {
  const badgeAddress = "0xa297944E0A63aDB57730687d44aF6235aa8D0DA7";
  const recipientAddress = process.argv[2] || "0xb024196a8c1AB0b4960E2060Ceb4Ba32a43F2C29";

  console.log("Minting test badge...");
  console.log("Badge Contract:", badgeAddress);
  console.log("Recipient:", recipientAddress);

  const SimpleZKBadge = await ethers.getContractFactory("SimpleZKBadge");
  const badge = SimpleZKBadge.attach(badgeAddress);

  const badgeType = process.argv[3] || "Proof of Uniqueness";
  const tx = await badge.issueBadge(
    recipientAddress,
    badgeType,
    `zk_proof_${badgeType}_${Date.now()}`
  );

  console.log("Transaction hash:", tx.hash);
  await tx.wait();
  console.log("Badge minted successfully!");

  const userBadges = await badge.getUserBadges(recipientAddress);
  console.log("User badges:", userBadges.map(id => id.toString()));
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
