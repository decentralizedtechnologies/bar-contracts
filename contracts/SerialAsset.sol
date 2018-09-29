pragma solidity ^0.4.24;

import './Asset.sol';
import './AssetSeries.sol';
import './Serial.sol';

/**
 * @title SerialAsset
 * @dev an Asset contract is tracked via an AssetSeries contract
 */
contract SerialAsset is Asset, Serial {

    /**
    * @dev The Asset constructor sets the original `owner` of the contract to the sender account.
    */
    constructor(
        address _owner, 
        string _description, 
        AssetSeries _assetSeries,
        uint256 _serialNumber
    ) public 
        Asset(_owner, _description) 
        Serial(_assetSeries, _serialNumber)
    {}
}