const hre = require("hardhat");
const { ethers, upgrades } = require("hardhat");
require("@nomiclabs/hardhat-waffle");
require('@openzeppelin/hardhat-upgrades');
require('dotenv').config();
const MYMARKETPLACECOIN = "MyMarketPlaceCoin";
const MARKETPLACEV1 = "MarketplaceV1";
const CURRENT_PROXY_ADDRESS = process.env.CURRENT_PROXY_ADDRESS;
const CONTRACT_NAME = 'MarketplaceV2'
async function main() {
    const MyMarketPlaceCoin = await ethers.getContractFactory("MyMarketPlaceCoin");
    const myMarketPlaceCoin = await MyMarketPlaceCoin.deploy();
    await myMarketPlaceCoin.deployed();
    // get contract factory and deploy marketplaceV1
    const MarketplaceV1 = await ethers.getContractFactory(MARKETPLACEV1);
    console.log('deploying ', MARKETPLACEV1)
    const marketplaceV1 = await upgrades.deployProxy(MarketplaceV1, { kind: 'uups' }); // deploy the marketplaceV1
    await marketplaceV1.deployed();

    // print data
    let implementationMarketplaceV1Address = await upgrades.erc1967.getImplementationAddress(marketplaceV1.address)
    console.log(MARKETPLACEV1, "(MarketplaceV1)  deployed to:", marketplaceV1.address);
    console.log("getImplementationAddress:", implementationMarketplaceV1Address)

    // get the contract factory and apply the upgrade
    const UpgradedContract = await ethers.getContractFactory(CONTRACT_NAME);
    console.log('upgrading ', CONTRACT_NAME)
    // create the new implementation contract and change the proxy pointer
    const upgradedContract = await upgrades.upgradeProxy(CURRENT_PROXY_ADDRESS, UpgradedContract);

    // log deployment info
    console.log("Implementation upgraded: ", upgradedContract.address);
    let implementationAddress = await upgrades.erc1967.getImplementationAddress(upgradedContract.address)
    console.log("new implementation address: ", implementationAddress)
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
