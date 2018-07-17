pragma solidity ^0.4.25;

import './node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol';

/**
 * @title Asset
 * @dev The Asset contract has an owner who can transfer the ownership of the asset
 * an Asset contract is tracked via an AssetSeries contract
 */
contract Asset is Ownable {

    /**
     * serialNumber
     * @var represents the position in the AssetSeries contract.
     * This value is set on the create method
     */
    uint256 public serialNumber;

    /**
     * passphrase
     * @var random generated string.
     * If the Asset contract has no owner. The user must 
     */
    uint256 public passphrase;

    /**
     * 
     */
    constructor (
        uint256 _passphrase, 
        uint256 _serialNumber) public {

        serialNumber = _serialNumber;
        passphrase = _passphrase;
    }

    /**
     * [setFirstOwner description]
     * @param {[type]} uint256 _passphrase [description]
     */
    function setFirstOwner(uint256 _passphrase) public {
        
        require(owner == address(0));
        require(_passphrase == passphrase);

        Owner owner = new Ownable();
    }
}
