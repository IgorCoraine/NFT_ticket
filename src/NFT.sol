// SPDX-License-Identifier: MIT
pragma solidity ^0.8.00;

import "erc721a/contracts/ERC721A.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";
import "openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

contract NFT is ERC721A, Ownable(msg.sender){
    using Strings for uint256;

    error MintPriceNotPaid();
    error MaxSupply();
    error MaxUser();
    error NonExistentTokenURI();
    error WithdrawTransfer();

    bool publicSale;
    bool preSale;

    mapping(address => uint256) walletMinted;
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
}