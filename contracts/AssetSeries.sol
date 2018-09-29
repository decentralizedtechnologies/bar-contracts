pragma solidity ^0.4.24;

import './SerialAsset.sol';

/**
 * @title AssetSeries
 * @dev a series of Asset contracts
 */
contract AssetSeries {

    modifier onlyIssuer() {
        require(msg.sender == issuer);
        _;
    }

    address public issuer;
    uint256 public serialNumber;
    uint256 public limit;
    uint256 public assetsCount = 0;
    string public description;
    mapping(uint256 => SerialAsset) public assetsBySerialNumber;

    event CreatedAsset(SerialAsset indexed asset);

    /*
    * @param _issuer the address creating the asset series
    * @param _serialNumber the incremental serial number from the AssetSeriesRegistry N+1
    * @param _limit The AssetSeries limit. 0 for unlimited series
    * @param _name The name of the series
    * @param _description The description field may be an IPFS hash with a JSON file
    */
    constructor(
        address _issuer,
        uint256 _serialNumber,
        uint256 _limit,
        string _description) public {
        issuer = _issuer;
        serialNumber = _serialNumber;
        limit = _limit;
        description = _description;
    }

    /**
     * @dev Create a new Asset contract
     */
    function newAsset(string _description) onlyIssuer public returns (SerialAsset) {
        require(assetsCount < limit, 'Cannot add more Asset contracts');
        ++assetsCount;
        SerialAsset asset = new SerialAsset(issuer, _description, this, assetsCount);
        assetsBySerialNumber[assetsCount] = asset;
        emit CreatedAsset(asset);
        return asset;
    }
}