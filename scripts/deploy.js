const hre = require("hardhat");

async function main() {

  // Deploy the contract
  const Faucet = await hre.ethers.getContractFactory("Faucet");
  const faucet = await Faucet.deploy();

  const contractAddress = (await faucet.deployTransaction.wait()).contractAddress;

  console.log("faucet contract deployed to:", contractAddress);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});