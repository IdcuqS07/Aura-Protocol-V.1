const hre = require("hardhat");

async function main() {
  console.log("🚀 Deploying CreditPassport to Polygon Amoy...\n");

  // Deploy CreditPassport
  console.log("Deploying CreditPassport...");
  const CreditPassport = await hre.ethers.getContractFactory("CreditPassport");
  const passport = await CreditPassport.deploy();
  await passport.waitForDeployment();

  const passportAddress = await passport.getAddress();
  console.log("✅ CreditPassport deployed to:", passportAddress);

  // Save deployment info
  const fs = require('fs');
  const deploymentInfo = {
    network: "amoy",
    contractName: "CreditPassport",
    address: passportAddress,
    deployer: (await hre.ethers.getSigners())[0].address,
    timestamp: new Date().toISOString(),
    blockNumber: await hre.ethers.provider.getBlockNumber()
  };

  fs.writeFileSync(
    './deployments/passport-amoy.json',
    JSON.stringify(deploymentInfo, null, 2)
  );

  console.log("\n📄 Deployment info saved to deployments/passport-amoy.json");
  console.log("\n🎉 Deployment complete!");
  console.log("\nContract Address:", passportAddress);
  console.log("Network: Polygon Amoy");
  console.log("\nVerify on PolygonScan:");
  console.log(`https://amoy.polygonscan.com/address/${passportAddress}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
