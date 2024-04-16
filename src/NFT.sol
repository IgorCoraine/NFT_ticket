// SPDX-License-Identifier: MIT
pragma solidity ^0.8.00;

import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";
import "openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721, Ownable(msg.sender){
    using Strings for uint256;

    error MintPriceNotPaid();
    error MaxSupply();
    error MaxUser();
    error NonExistentTokenURI();
    error WithdrawTransfer();
    error PublicSaleClose();
    error PreSaleClose();
    error MintPriceNotCorrect();
    error InvalidTokenId();
    error NotEnoughEther();
    error TransferFailed();

    bool publicSale;
    bool preSale;

    mapping(address => bool) preSaleList;

    uint256 public limitPerWallet;

    uint256 public TOTALSUPPLY;
    uint256 immutable MINT_PRICE;

    string public baseURI;
    string public collectionCover = "https://ipfs.io/ipfs/QmUuvN2g7uTgGy2r2j45suuCJSvV4JGiy1779azQLxgRW5/";

    constructor(
        uint256 _TOTALSUPPLY,
        uint256 _limitPerWallet,
        uint256 _limitQuantity,
        uint256 _MINT_PRICE,
        string memory _baseURI
    )
        ERC721A("IgorCoraine", "CORA")
    {
        TOTALSUPPLY = _TOTALSUPPLY;
        limitPerWallet = _limitPerWallet;
        limitQuantity = _limitQuantity;
        MINT_PRICE = _MINT_PRICE;
        baseURI = _baseURI;
        preSaleList[msg.sender] = true; //insert deploy address at preSaleList
    }

    function mintPublic(uint256 tokenId) external payable supplyMax(quantity) limitUser(quantity) {
        if (!publicSale) revert PublicSaleClose();
        if (msg.value != MINT_PRICE * quantity) revert MintPriceNotCorrect();
        _safeMint(msg.sender, tokenId);
    }

    function mintPresale(uint256 tokenId) external payable supplyMax(quantity) limitUser(quantity) {
        whitelistFunc();
        if (!preSale) revert PreSaleClose();
        if (msg.value != MINT_PRICE * quantity) revert MintPriceNotCorrect();
        _safeMint(msg.sender, tokenId);
    }

    function contractURI() //collection cover
        external
        view
        returns (string memory)
    {
        return string(abi.encodePacked(collectionCover)); 
    }

    function addToPresalelist(address toAddAddresses) external onlyOwner {
        preSaleList[toAddAddresses] = true;
    }

    /**
     * @notice Remove from whitelist
     */
    function removeFromPresalelist(address toRemoveAddresses) external onlyOwner {
        preSaleList[toRemoveAddresses] = false;
    }

     function publicSaleActive() external onlyOwner {
        publicSale = true;
    }

    function preSaleActive() external onlyOwner {
        preSale = true;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        if (ownerOf(tokenId) == address(0)) revert InvalidTokenId();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    function withdraw() public payable onlyOwner {
        uint256 balance = address(this).balance;
        if (balance == 0) revert WithdrawTransfer();
        (bool success,) = (msg.sender).call{ value: balance }("");
        if (!success) revert TransferFailed();
    }

    modifier supplyMax(uint256 _quantity) {
        if (_quantity >= TOTALSUPPLY) revert MaxSupply();
        _;
    }

    modifier limitUser(uint256 _quantity) {
        if (mintWallet[msg.sender] >= limitPerWallet) revert MaxUser();
        if (_quantity >= limitQuantity) revert MaxUser();
        _;
    }

}