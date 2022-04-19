// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

contract MyMarketPlaceCoin is
    Initializable,
    ERC721Upgradeable,
    ERC721EnumerableUpgradeable,
    ERC721URIStorageUpgradeable,
    OwnableUpgradeable,
    UUPSUpgradeable
{
    using CountersUpgradeable for CountersUpgradeable.Counter;

    CountersUpgradeable.Counter private _tokenIds;
    address private marketplace;

    /**
     *marketplace getter setter
     */
    function getMarketplace() public view returns (address) {
        return marketplace;
    }

    function setMarketplace(address market) public {
        marketplace = market;
    }

    /*end*/
    /*sell item*/
    struct Item {
        uint256 id;
        address creator;
        string uri; //metadata url
    }

    mapping(uint256 => Item) public Items; //id => Item

    /*end*/
    /**
     *constructor
     */
    // constructor() ERC721("MyMarketPlaceCoin", "MMP") {}
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function initialize() public initializer {
        __ERC721_init("MyMarketPlaceCoin", "MMP");
        __ERC721Enumerable_init();
        __ERC721URIStorage_init();
        __Ownable_init();
        __UUPSUpgradeable_init();
    }

    /*end*/
    /**
     *override
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    )
        internal
        virtual
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        virtual
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyOwner
    {}

    /*end*/
    function mint(string memory uri) public returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        approve(marketplace, newItemId);
        Items[newItemId] = Item({id: newItemId, creator: msg.sender, uri: uri});
        return newItemId;
    }
}
