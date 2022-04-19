// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;
import "../coins/MyMarketPlaceCoin.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/StorageSlot.sol";
import "./MarketplaceV1.sol";

contract MarketplaceV2 is MarketplaceV1 {
    function version() public pure virtual override returns (string memory) {
        return "V2";
    }

    function CreateOrder(uint256 tokenId, uint256 price)
        external
        override
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
        override
        ItemExists(id)
        HasTransferApproval(items[id].tokenId)
    {
        uint256 price = items[id].price;
        uint256 payForSeller = price - ((price / 4) / 100);

        uint256 payForTreasury = ((price / 4) / 100) + ((price / 4) / 100);

        require(
            msg.value >= payForSeller + payForTreasury,
            "Not enough funds sent"
        );

        require(msg.sender != items[id].seller);

        items[id].isSold = true;
        super.getToken().safeTransferFrom(
            items[id].seller,
            msg.sender,
            items[id].tokenId
        );
        items[id].seller.transfer(msg.value);
        address payable treasuryAddress = payable(super.getTreasuryAddress());
        treasuryAddress.transfer(payForTreasury);
        emit itemSold(id, msg.sender, items[id].price);
    }
}
