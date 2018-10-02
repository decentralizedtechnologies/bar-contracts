pragma solidity ^0.4.24;

import './AssetSeries.sol';
import './Asset.sol';

/**
 * @title AssetRegistry
 * @dev 
 * Create and keep track of the AssetSeries contracts
 */
contract AssetRegistry {

    uint256 public serialNumber = 0;
    mapping (address => AssetSeries[]) public assetSeriesByIssuer;
    
    uint256 public assetsCount = 0;
    mapping (address => Asset[]) public assetsByIssuer;

    event CreatedAssetSeries(AssetSeries indexed assetSeries);
    event CreatedAsset(Asset indexed asset);

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
    
    /**
     * Create a new Asset contract without an AssetSeries
     */
    function newAsset(
    string description) 
    public 
    returns (Asset) {
        address issuer = msg.sender;
        Asset asset = new Asset(issuer, description);
        assetsByIssuer[issuer].push(asset);
        ++assetsCount;
        emit CreatedAsset(asset);
        return asset;
    }

    /*
    * @dev gets the length of the AssetSeries array of a given issuer
    */
    function getAssetSeriesCountByIssuer(address _issuer) public view returns (uint count) {
        return assetSeriesByIssuer[_issuer].length;
    }
    
    /*
    * @dev gets the length of the Asset contracts array of a given issuer
    */
    function getAssetsCountByIssuer(address _issuer) public view returns (uint count) {
        return assetsByIssuer[_issuer].length;
    }
}