pragma solidity ^0.4.24;

import 'node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol';

/**
 * @title Asset
 * @dev The Asset contract has an owner who can transfer the ownership of the asset
 * an Asset contract is tracked via an AssetSeries contract
 */
contract Asset is Ownable {

    address[] public owners;
    address public pendingOwner;

    event PendingOwnership(
        address indexed owner,
        address indexed pendingOwner);

    constructor() public Ownable() {
        owners.push(msg.sender);
    }

    function transfer(address _newOwner) public onlyOwner {
        pendingOwner = _newOwner;
        emit PendingOwnership(owner, pendingOwner);
    }

    function claim() public {
        require(msg.sender == pendingOwner, 'Asset cannot be accepted');
        transferOwnership(msg.sender);
        owners.push(owner);
    }
}