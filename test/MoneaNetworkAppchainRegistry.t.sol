// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {MoneaNetworkAppchainRegistry} from "../src/MoneaNetworkAppchainRegistry.sol";

enum NetworkType {
    DEVNET,
    TESTNET,
    MAINNET
}

struct Appchain {
    uint256 chainId;
    string name;
    address gasTokenAddress;
    bool isActive;
    NetworkType networkType;
    address deployer;
    bytes data;
}

// TODO finish tests when ready to deploy MVP (no tests for PoC is okay for now)

contract MoneaNetworkAppchainRegistryTest is Test {
    MoneaNetworkAppchainRegistry public registry;

    address moneaOwner = address(0x141414);
    address friendlyDeployer = address(0x777);
    address unfriendlyDeployer = address(0x666);

    function setUp() public {
        registry = new MoneaNetworkAppchainRegistry(moneaOwner);
    }

    // function test_getNonexistentAppchain() public {
    //     Appchain memory appchain = registry.getAppchainByChainId(0);
    //     assertEq(
    //         appChain.gasTokenAddress,
    //         0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
    //     );
    // }
}
