pragma solidity ^0.4.24;

import './AssetSeries.sol';

/**
 * @title Serial
 * @dev an Asset contract created from an AssetSeries contract is tracked via a Serial contract
 */
contract Serial {

    AssetSeries public assetSeries;
    uint256 public serialNumber;

    constructor(
        AssetSeries _assetSeries, 
        uint256 _serialNumber
    ) public {
        assetSeries = _assetSeries;
        serialNumber = _serialNumber;
    }
}