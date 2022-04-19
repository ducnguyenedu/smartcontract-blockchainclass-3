const hre = require("hardhat");
const { ethers, upgrades } = require("hardhat");
require("@nomiclabs/hardhat-waffle");
require('@openzeppelin/hardhat-upgrades');
require('dotenv').config();

const CURRENT_PROXY_ADDRESS = process.env.CURRENT_PROXY_ADDRESS;
async function main() {
    // Deploying
    const MyMarketPlaceCoin = await ethers.getContractFactory("MyMarketPlaceCoin");
    const MMP = await MyMarketPlaceCoin.deploy();
    await MMP.deployed();
    console.log("MyMarketPlaceCoin: ", MMP.address);
    console.log("1");
    const MarketplaceV1 = await ethers.getContractFactory("MarketplaceV1");
    console.log("2");
    const marketplaceV1 = await MarketplaceV1.deploy();
    // const marketplaceV1 = await upgrades.deployProxy(MarketplaceV1);
    console.log("3");
    await marketplaceV1.deployed();
    console.log("MarketplaceV1: ", marketplaceV1.address);
    // Upgrading
    const MarketplaceV2 = await ethers.getContractFactory("MarketplaceV2");
    console.log("4");
    const marketplaceV2 =  await MarketplaceV2.deploy();
    await marketplaceV2.deployed();
    // const marketplaceV2 = await upgrades.upgradeProxy(marketplaceV1.address, MarketplaceV2);
    console.log("MarketplaceV2: ", marketplaceV2.address);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
