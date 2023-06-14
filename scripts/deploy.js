const hre = require("hardhat");

async function main() {

  // Deploy the contract
  const Clay = await hre.ethers.getContractFactory("CLAYInTheBlockchainLand");
  const clay = await Clay.deploy();

  const contractAddress = (await clay.deployTransaction.wait()).contractAddress;

  console.log("Clay contract deployed to:", contractAddress);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});