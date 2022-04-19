// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;
import "../coins/MyMarketPlaceCoin.sol";
import "../../library/Converter.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract MarketplaceV1 is
    Initializable,
    OwnableUpgradeable,
    Converter,
    UUPSUpgradeable
{
    MyMarketPlaceCoin private token;
    address private TreasuryAddress ;
    event changeTreasuryAddress(address from, address to);

    function getTreasuryAddress() public view returns (address) {
        return TreasuryAddress;
    }

    function setTreasuryAddress(address _newTreasuryAddress) public onlyOwner {
        address oldTreasuryAddress = TreasuryAddress;
        TreasuryAddress = payable(_newTreasuryAddress);
        emit changeTreasuryAddress(oldTreasuryAddress, _newTreasuryAddress);
    }

    function getToken() public view returns (MyMarketPlaceCoin) {
        return token;
    }

    function setToken(string memory _token) public {
        token = MyMarketPlaceCoin(toAddress(_token));
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {
        console.log(version());
    }

    function initialize() public initializer {
        __Ownable_init();
        __UUPSUpgradeable_init();
        console.log(version());
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyOwner
    {}

    struct Item {
        uint256 id;
        uint256 tokenId;
        address payable seller;
        uint256 price;
        bool isSold;
    }
    Item[] public items;
    event itemSold(uint256 id, address buyer, uint256 price);
    event SellerCreateOrder(uint256 id, uint256 tokenId, uint256 price);
    event changePrice(uint256 item, uint256 oldPrice, uint256 newPrice);
    /*
     * Modifier
     */

    modifier HasTransferApproval(uint256 tokenId) {
        require(
            token.getApproved(tokenId) == address(this),
            "Market is not approved"
        );
        _;
    }
    modifier OnlyItemOwner(uint256 tokenId) {
        require(
            token.ownerOf(tokenId) == msg.sender,
            "Sender does not own the item"
        );
        _;
    }
    modifier ItemExists(uint256 id) {
        require(id < items.length && items[id].id == id, "Could not find item");
        _;
    }

    modifier IsForSale(uint256 id) {
        require(!items[id].isSold, "Item is already sold");
        _;
    }

    /*
     * end
     */
    /*
     * Market action
     * Sell buy view changeprice
     */
    function CreateOrder(uint256 tokenId, uint256 price)
        external
        virtual
        OnlyItemOwner(tokenId)
        HasTransferApproval(tokenId)
        returns (uint256)
    {
        uint256 newItemId = items.length;
        items.push(
            Item({
                id: newItemId,
                tokenId: tokenId,
                seller: payable(msg.sender),
                price: price,
                isSold: false
            })
        );

        assert(items[newItemId].id == newItemId);
        emit SellerCreateOrder(newItemId, tokenId, price);
        return newItemId;
    }

    function MatchOrder(uint256 id)
        external
        payable
        virtual
        ItemExists(id)
        HasTransferApproval(items[id].tokenId)
    {
        require(msg.value >= items[id].price, "Not enough funds sent");
        require(msg.sender != items[id].seller);

        items[id].isSold = true;
        getToken().safeTransferFrom(
            items[id].seller,
            msg.sender,
            items[id].tokenId
        );
        items[id].seller.transfer(msg.value);

        emit itemSold(id, msg.sender, items[id].price);
    }

    function viewItem() public view returns (Item[] memory) {
        return items;
    }

    function changePriceItem(uint256 _itemId, uint256 _newPrice)
        public
        OnlyItemOwner(_itemId)
        IsForSale(_itemId)
    {
        uint256 _oldPrice = items[_itemId].price;
        items[_itemId].price = _newPrice;

        emit changePrice(_itemId, _oldPrice, _newPrice);
    }

    /*
     * end
     */
    function version() public pure virtual returns (string memory) {
        return "V1";
    }
}
