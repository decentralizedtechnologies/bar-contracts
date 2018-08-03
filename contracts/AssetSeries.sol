pragma solidity ^0.4.24;

import './Asset.sol';

/**
 * @title AssetSeries
 * @dev 
 * an Asset contract is tracked via an AssetSeries contract
 */
contract AssetSeries {

    modifier onlyIssuer() {
        require(msg.sender == issuer);
        _;
    }

    address public issuer;

    uint256 public serialNumber;

    uint256 public limit;

    string public name;

    string public description;
    
    Asset[] public assets;

    event CreatedAsset(Asset asset);

    constructor(
        address _issuer,
        uint256 _serialNumber,
        uint256 _limit,
        string _name,
        string _description) public {

        issuer = _issuer;
        serialNumber = _serialNumber;
        limit = _limit;
        name = _name;
        description = _description;
    }

    /**
     * Create a new Asset contract
     */
    function add() public onlyIssuer {
        require(assets.length <= limit, 'Cannot add more Asset contracts');
        Asset asset = new Asset();
        assets.push(asset);
        emit CreatedAsset(asset);
    }
}