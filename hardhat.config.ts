import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-chai-matchers";

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  networks: {
    matic_mumbai: {
      url: process.env.POLYGON_URL,
      accounts: [process.env.PRIVATE_KEY]
    }
  }

};

export default config;
