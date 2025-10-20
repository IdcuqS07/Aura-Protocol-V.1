const { ethers } = require("hardhat");

async function main() {
  console.log("Deploying Aura Protocol contracts to Polygon testnet...");

  // Get the deployer account
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);
  console.log("Account balance:", (await ethers.provider.getBalance(deployer.address)).toString());

  // Deploy SimpleZKBadge contract
  console.log("\nDeploying SimpleZKBadge...");
  const SimpleZKBadge = await ethers.getContractFactory("SimpleZKBadge");
  const zkBadge = await SimpleZKBadge.deploy();
  await zkBadge.waitForDeployment();
  console.log("SimpleZKBadge deployed to:", await zkBadge.getAddress());

  const zkBadgeAddress = await zkBadge.getAddress();

  // Save deployment addresses
  const deploymentInfo = {
    network: "localhost",
    contracts: {
      SimpleZKBadge: zkBadgeAddress
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