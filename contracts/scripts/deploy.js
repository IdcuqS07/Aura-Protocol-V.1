const { ethers } = require("hardhat");

async function main() {
  console.log("Deploying Aura Protocol contracts to Polygon testnet...");

  // Get the deployer account
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  // Deploy AuraZKBadge contract
  console.log("\nDeploying AuraZKBadge...");
  const AuraZKBadge = await ethers.getContractFactory("AuraZKBadge");
  const zkBadge = await AuraZKBadge.deploy();
  await zkBadge.deployed();
  console.log("AuraZKBadge deployed to:", zkBadge.address);

  // Deploy CivicIntegration contract
  console.log("\nDeploying CivicIntegration...");
  const CivicIntegration = await ethers.getContractFactory("CivicIntegration");
  const civicIntegration = await CivicIntegration.deploy(zkBadge.address);
  await civicIntegration.deployed();
  console.log("CivicIntegration deployed to:", civicIntegration.address);

  // Deploy WorldcoinIntegration contract
  console.log("\nDeploying WorldcoinIntegration...");
  const WorldcoinIntegration = await ethers.getContractFactory("WorldcoinIntegration");
  const worldcoinIntegration = await WorldcoinIntegration.deploy(
    zkBadge.address,
    "0x1234567890123456789012345678901234567890", // WorldID contract address (replace with actual)
    "app_staging_12345", // App ID
    "verify-human" // Action ID
  );
  await worldcoinIntegration.deployed();
  console.log("WorldcoinIntegration deployed to:", worldcoinIntegration.address);

  // Authorize verifiers
  console.log("\nAuthorizing verifiers...");
  
  // Authorize CivicIntegration for CIVIC badge type
  await zkBadge.authorizeVerifier(civicIntegration.address, 3); // BadgeType.CIVIC = 3
  console.log("CivicIntegration authorized for CIVIC badges");
  
  // Authorize WorldcoinIntegration for WORLDCOIN badge type
  await zkBadge.authorizeVerifier(worldcoinIntegration.address, 4); // BadgeType.WORLDCOIN = 4
  console.log("WorldcoinIntegration authorized for WORLDCOIN badges");

  // Save deployment addresses
  const deploymentInfo = {
    network: "polygon-mumbai",
    contracts: {
      AuraZKBadge: zkBadge.address,
      CivicIntegration: civicIntegration.address,
      WorldcoinIntegration: worldcoinIntegration.address
    },
    deployer: deployer.address,
    timestamp: new Date().toISOString()
  };

  console.log("\n=== Deployment Summary ===");
  console.log(JSON.stringify(deploymentInfo, null, 2));
  
  // Save to file
  const fs = require('fs');
  fs.writeFileSync('deployment.json', JSON.stringify(deploymentInfo, null, 2));
  console.log("\nDeployment info saved to deployment.json");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });