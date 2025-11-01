const { ethers } = require("hardhat");

async function main() {
  const badgeAddress = "0xa297944E0A63aDB57730687d44aF6235aa8D0DA7";
  const minterAddress = process.argv[2];

  if (!minterAddress) {
    console.log("Usage: npx hardhat run scripts/authorize-minter.js --network polygon-amoy <MINTER_ADDRESS>");
    process.exit(1);
  }

  console.log("Authorizing minter:", minterAddress);

  const badge = await ethers.getContractAt("SimpleZKBadge", badgeAddress);
  const tx = await badge.authorizeMinter(minterAddress);
  await tx.wait();

  console.log("Minter authorized!");
  console.log("Transaction:", tx.hash);
}

main().catch(console.error);
