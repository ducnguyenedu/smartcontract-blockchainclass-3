require("@nomiclabs/hardhat-waffle");
require('dotenv').config();
// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
const accountsList = [];
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();
  const i = 0;
  for (const account of accounts) {
    accountsList[i] = account.address + "";
    console.log(account.address);
    i++;
  }
});
// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more
/**
 * @type import('hardhat/config').HardhatUserConfig
 */
require("@nomiclabs/hardhat-waffle");
require('@openzeppelin/hardhat-upgrades');
// Go to https://www.alchemyapi.io, sign up, create
// a new App in its dashboard, and replace "KEY" with its key
// Replace this private key with your Ropsten account private key
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Be aware of NEVER putting real Ether into testing accounts
const API_KEY = process.env.API_KEY;
// Replace this private key with your Ropsten account private key
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Be aware of NEVER putting real Ether into testing accounts
const PRIVATE_KEY = process.env.PRIVATE_KEY;
module.exports = {
  solidity: "0.8.13",
  networks: {
    hardhat:{},
    rinkeby: {
      url: 'https://rinkeby.infura.io/v3/' + API_KEY,
      accounts: [PRIVATE_KEY]
    },
  }
};
