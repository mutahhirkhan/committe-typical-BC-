require("@nomiclabs/hardhat-waffle");

const mnemonic = process.env.MNEMONIC
const rinkebyApiKey = process.env.INFURA_RINKEBY_API_KEY
const privateKey = process.env.PRIVATE_KEY
const alchemyRinkebyApi = process.env.ALCHEMY_RINKEY_KEY


// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
    const accounts = await hre.ethers.getSigners();

    for (const account of accounts) {
        console.log(account.address);
    }
});

  module.exports = {
    defaultNetwork: "rinkeby",
    networks: {
      rinkeby: {
        url: `${alchemyRinkebyApi}`,
        accounts: [`${privateKey}`]
      }
    },
    solidity: {
      version: "0.8.4",
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        }
      }
    },
    paths: {
      sources: "./contracts",
      tests: "./test",
      cache: "./cache",
      artifacts: "./artifacts"
    },
    mocha: {
      timeout: 20000
    }
  }

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
    solidity: "0.8.4",
};
