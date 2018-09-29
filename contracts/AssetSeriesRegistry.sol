pragma solidity ^0.4.24;

import './AssetSeries.sol';

/**
 * @title AssetSeriesRegistry
 * @dev 
 * Create and keep track of the AssetSeries contracts
 */
contract AssetSeriesRegistry {

    uint256 public serialNumber = 0;
    mapping (address => AssetSeries[]) public assetSeriesByIssuer;

    event CreatedAssetSeries(AssetSeries indexed assetSeries);

    /**
     * Create a new AssetSeries contract
     */
    function newAssetSeries(
    uint256 limit, 
    string description) 
    public 
    returns (AssetSeries) {
        address issuer = msg.sender;
        ++serialNumber;
        AssetSeries assetSeries = new AssetSeries(issuer, serialNumber, limit, description);
        assetSeriesByIssuer[issuer].push(assetSeries);
        emit CreatedAssetSeries(assetSeries);
        return assetSeries;
    }

    /*
    * @dev gets the length of the AssetSeries array of a given issuer
    */
    function getAssetSeriesCountByIssuer(address _issuer) public view returns (uint count) {
        return assetSeriesByIssuer[_issuer].length;
    }
}