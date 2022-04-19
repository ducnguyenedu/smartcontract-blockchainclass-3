# Smartcontract-blockchainclass-project-3
### Basic Sample Hardhat Project
This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts.
Try running some of the following tasks:
```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/deploy.js --network rinkeby
npx hardhat help
```

## Proxy Deploy:
```shell
node scripts/proxydeploy.js --network rinkeby
```
⚠️Can run but not finish: 
need to add  MyMarketPlaceCoin token to constructor
```shell
    constructor() initializer {}

    function initialize() public initializer {
        __Ownable_init();
        __UUPSUpgradeable_init();
    }
```
https://github.com/Sotatek-DucNguyen6/smartcontract-blockchainclass-project-3/blob/main/contracts/model/marketplace/MarketplaceV1.sol
#### Deployed to: 
0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
#### Implementation Address: 
0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512

### Another Class Project:

[Project 1](https://github.com/ducnguyenedu/smartcontract-blockchainclass-project-1)

[Project 2](https://github.com/ducnguyenedu/smartcontract-blockchainclass-project-2)
