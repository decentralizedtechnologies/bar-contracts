pragma solidity ^0.4.24;

import './AssetSeries.sol';

/**
 * @title AssetSeriesRegistry
 * @dev 
 * Create and keep track of the AssetSeries contracts
 */
contract AssetSeriesRegistry {

    event CreatedAssetSeries(AssetSeries assetSeries);

    uint256 public serialNumber = 0;
    mapping (address => AssetSeries[]) public assetsSeriesByIssuer;

    /**
     * Create a new AssetSeries contract
     */
    function create(
    uint256 limit, 
    string name, 
    string description) 
    public {
        address issuer = msg.sender;
        ++serialNumber;
        AssetSeries assetSeries = new AssetSeries(issuer, serialNumber, limit, name, description);
        assetsSeriesByIssuer[issuer].push(assetSeries);
        emit CreatedAssetSeries(assetSeries);
    }
}