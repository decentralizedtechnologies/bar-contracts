pragma solidity ^0.5.2;

import "./Versioned.sol";
import "node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";

/**
 * @title OwnableAsset
 * @dev Register whatever you own in the Ethereum blockchain
 * blockchainassetregistry.com
 */
contract OwnableAsset is Versioned, Ownable {
}
