pragma solidity ^0.4.25;

import './Asset.sol';

/**
 * @title AssetSeries
 * @dev 
 * an Asset contract is tracked via an AssetSeries contract
 */
contract AssetSeries {

    /**
     * creator
     * @var indicates the creator of this AssetSeries contract.
     * eg. a caps factory. Each cap is an Asset contract linked to this AssetSeries
     */
    address public creator;

    /**
     * series
     * @var indicates the supply of the number of Asset contracts linked to this series
     * 0 means unlimited supply
     */
    uint256 public series;

    /**
     * currentAssetNumber
     * @var 
     * 
     */
    uint256 public currentAssetNumber;

    /**
     * assets
     * @var Asset contracts to be linked.
     */
    mapping (adress => Asset) public assets;

    /**
     * 
     */
    constructor(uint256 _series) public {

        require(_series >= 0);

        series = _series;
        currentAssetNumber = 0;
    }

    /**
     * createAsset Creates new Asset contract and increments the serial number
     * @param  {[type]} ) public        returns (address Asset [description]
     * @return {[type]}   [description]
     */
    function createAsset(uint256 passphrase) public returns (address Asset) {

        currentAssetNumber = currentAssetNumber + 1;
        require(currentAssetNumber <= series);

        Asset asset = new Asset(passphrase, currentAssetNumber);

        assets[asset] = asset;

        return asset;
    }

}