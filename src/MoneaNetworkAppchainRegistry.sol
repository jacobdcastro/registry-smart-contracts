// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

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

/// @title Registry of Appchains deployed on Monea Network
/// @author Jacob D. Castro <jacob@monea.xyz>
/// @notice This is primarily a read-only registry for most users. This is an initial implementation and is subject to change.
/// @custom:security-contact security@monea.xyz
contract MoneaNetworkAppchainRegistry is Pausable, Ownable {
    address private constant ETH_ADDRESS =
        0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    event AppchainRegistered(uint256 chainId, address indexed registerer);

    constructor(address initialOwner) Ownable(initialOwner) {}

    // chainId -> Appchain
    mapping(uint256 => Appchain) public appchainRegistry;

    // deployerAddress -> bool
    mapping(address => bool) public bannedDeployers;

    modifier onlyOwnerOrDeployer(uint256 chainId) {
        require(
            msg.sender == owner() ||
                msg.sender == appchainRegistry[chainId].deployer,
            "MoneaNetworkAppchainRegistry: caller is not the owner or deployer"
        );
        _;
    }

    modifier noZeroChainId(uint256 chainId) {
        require(
            chainId != 0,
            "MoneaNetworkAppchainRegistry: chainId cannot be zero"
        );
        _;
    }

    modifier deployerIsNotBanned(address deployer) {
        require(
            !bannedDeployers[deployer],
            "MoneaNetworkAppchainRegistry: deployer is banned"
        );
        _;
    }

    function getAppchainByChainId(
        uint256 chainId
    ) external view returns (Appchain memory) {
        return appchainRegistry[chainId];
    }

    function addAppchain(
        uint256 chainId,
        string memory name,
        address gasTokenAddress,
        bool isActive,
        NetworkType networkType,
        address deployer,
        bytes memory data
    )
        external
        whenNotPaused
        onlyOwner
        noZeroChainId(chainId)
        deployerIsNotBanned(deployer)
    {
        require(
            appchainRegistry[chainId].chainId == 0,
            "MoneaNetworkAppchainRegistry: chainId already exists"
        );
        appchainRegistry[chainId] = Appchain(
            chainId,
            name,
            gasTokenAddress,
            isActive,
            networkType,
            deployer,
            data
        );
        emit AppchainRegistered(chainId, msg.sender);
    }

    function updateAppchain(
        uint256 chainId,
        string memory name,
        address gasTokenAddress,
        bool isActive,
        NetworkType networkType,
        address deployer,
        bytes memory data
    )
        external
        whenNotPaused
        noZeroChainId(chainId)
        onlyOwnerOrDeployer(chainId)
        deployerIsNotBanned(msg.sender)
    {
        require(
            appchainRegistry[chainId].chainId != 0,
            "MoneaNetworkAppchainRegistry: chainId does not exist"
        );
        appchainRegistry[chainId] = Appchain(
            chainId,
            name,
            gasTokenAddress,
            isActive,
            networkType,
            deployer,
            data
        );
    }

    function banDeployer(address deployer) external whenNotPaused onlyOwner {
        bannedDeployers[deployer] = true;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}
