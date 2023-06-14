const hre = require("hardhat");
const { expect } = require("chai");

describe("RPC", function () {
  let contractAddress;
  let signers;

  before(async function () {
    signers = await hre.ethers.getSigners();
  });

  it("should be able to get the account balance", async function () {
    const balance = await hre.run("show-balance");
    expect(Number(balance)).to.be.greaterThan(0);
  });

  it("should be able to deploy a contract", async function () {
    contractAddress = await hre.run("deploy-contract");
    expect(contractAddress).to.not.be.null;
  });
});