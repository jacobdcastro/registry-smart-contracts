// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @custom:security-contact security@monea.xyz
contract MoneaNetworkAppchainRegistry is Pausable, Ownable {
    constructor(address initialOwner) Ownable(initialOwner) {}

    uint64 public constant MAX_CHAIN_ID = (uint64() / 2) - 36;

    struct Appchain {
        uint256 chainId;
        string name;
        string rpcUrl;
        string bridgeUrl;
        string bridgeAddress;
        string bridgeAbi;
        string tokenAddress;
        string tokenAbi;
        string tokenSymbol;
        string tokenDecimals;
        string tokenName;
        string tokenLogo;
        string tokenBridgeAddress;
        string tokenBridgeAbi;
        string tokenBridgeUrl;
        string tokenBridgeSymbol;
        string tokenBridgeDecimals;
        string tokenBridgeName;
        string tokenBridgeLogo;
    }

    // chainId -> appchainName
    mapping(uint256 => string) public appchainRegistry;

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
}
