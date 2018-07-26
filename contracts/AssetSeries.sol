pragma solidity ^0.4.24;

import './Asset.sol';
import './Migratable.sol';

/**
 * @title AssetSeries
 * @dev 
 * an Asset contract is tracked via an AssetSeries contract
 */
contract AssetSeries is Migratable {

    Asset asset;

    mapping (address => mapping (uint256 => Series)) internal series;
    mapping (address => uint256[]) internal seriesByCreator;

    uint256 public currentSeries = 0;

    struct Series {
        uint256 id;
        uint256 limit;
        string name;
        string description;
        address creator;
        uint256[] items;
    }

    
    function initialize(Asset _asset) 
    public 
    isInitializer("AssetSeries", "0.0.1") {
        
        asset = Asset(_asset);
        asset.setOwner();

    }

    function getAssetContractAddress() public view returns (address _asset) {
        return address(asset);
    }

    function createSeries(
        uint256 _limit,
        string _name,
        string _description) public {

        require(_limit >= 0, 'Limit must be equal or greater than 0');

        ++currentSeries;
        series[msg.sender][currentSeries].id = currentSeries;
        series[msg.sender][currentSeries].limit = _limit;
        series[msg.sender][currentSeries].name = _name;
        series[msg.sender][currentSeries].description = _description;
        series[msg.sender][currentSeries].creator = msg.sender;

        seriesByCreator[msg.sender].push(currentSeries);

    }

    function getSeriesByIdFromCreator(address _creator, uint256 seriesId) 
    public 
    view 
    returns (
    uint256 id,
    uint256 limit,
    string name,
    string description,
    address creator,
    uint256[] items
    ) {
        require(series[_creator][seriesId].id > 0, 'Series does not exist for this creator address');

        return (
            series[_creator][seriesId].id,
            series[_creator][seriesId].limit,
            series[_creator][seriesId].name,
            series[_creator][seriesId].description,
            series[_creator][seriesId].creator,
            series[_creator][seriesId].items
            );
    }

    function getSeriesIdsFromAddress(address _creator) public view returns (uint256[]) {
        return seriesByCreator[_creator];
    }

    function addAsset(uint256 seriesId) public {

        require(series[msg.sender][seriesId].id > 0, 'Series does not exist for this creator address');
        require(series[msg.sender][seriesId].limit <= asset.currentItemBySeriesId(seriesId), 'Cannot add more items to this series');

        uint256 serialNumber = asset.create(seriesId);
        series[msg.sender][seriesId].items.push(serialNumber);

    }

    function getAssetsBySeriesId(uint256 seriesId, address _creator) public view returns (uint256[]) {
        require(series[_creator][seriesId].id > 0, 'Series does not exist for this creator address');
        return series[_creator][seriesId].items;
    }
}