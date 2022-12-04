import { ethers } from "hardhat";

async function main() {
  const WeFunderContractFactory = await ethers.getContractFactory("WeFunder");
  const WeFunderContract = await WeFunderContractFactory.deploy();
  await WeFunderContract.deployed();

  console.log(`WeFunder Contract Deployed To address ${WeFunderContract.address}`)
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
