// SPDX-License-Identifier: MIT
pragma solidity ^0.8.00;

import { NFT } from "../src/NFT.sol";

import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract Deploy is BaseScript {
    uint256 _TOTALSUPPLY = 17;
    uint256 _limitPerWallet = 5;
    uint256 _limitQuantity = 5;
    uint256 _MINT_PRICE = 1 ether;
    string _baseURI = "ipfs://QmWXUkLnC6MiGiofx2hfTJV4RojwZaWVKbeTyRsTAQwo15";

    function run() public broadcast returns (Collection token) {
        token = new NFT(_TOTALSUPPLY, _limitPerWallet,
        _limitQuantity,
        _MINT_PRICE,
        _baseURI); // constructor params
    }
}