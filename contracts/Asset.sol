pragma solidity ^0.4.24;

import 'node_modules/openzeppelin-solidity/contracts/ownership/Claimable.sol';

/**
 * @title Asset
 * @dev The Asset contract has an owner who can transfer the ownership of the asset
 * an Asset contract is tracked via an AssetSeries contract
 */

contract Asset is Claimable {
    constructor() public Ownable() {}
    function() external {}
}