pragma solidity ^0.4.24;

import './Migratable.sol';
import './AssetSeries.sol';

/**
 * @title Asset
 * @dev The Asset contract has an owner who can transfer the ownership of the asset
 * an Asset contract is tracked via an AssetSeries contract
 */
contract Asset is Migratable {

    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    struct Item {
        uint256 serialNumber;
        bytes32 passphrase;
        address owner;
    }

    mapping (uint256 => mapping (uint256 => Item)) internal items;
    mapping (uint256 => uint256) public currentItemBySeriesId;

    function initialize()
    public 
    isInitializer("Asset", "0.0.1") {}

    function setOwner() public {
        require(owner == address(0), 'AssetSeries contract is the owner of this Asset contract');

        owner = msg.sender;
    }

    function create(uint256 seriesId) public onlyOwner returns (uint256) {

        currentItemBySeriesId[seriesId] = (items[seriesId][1].serialNumber == 0) ? 1 : currentItemBySeriesId[seriesId] + 1;

        uint256 serialNumber = currentItemBySeriesId[seriesId];
        
        Item storage item = items[seriesId][serialNumber];

        item.serialNumber = serialNumber;

        bytes32 passphrase = keccak256(abi.encodePacked(seriesId, serialNumber, "createAsset"));
        item.passphrase = passphrase;

        return serialNumber;
    }

    function getItemBySeriesId(
        uint256 seriesId, 
        uint256 serialNumber) 
    public 
    view
    returns (
    uint256 _serialNumber,
    bytes32 passphrase,
    address _owner
    ) {
       return (
            items[seriesId][serialNumber].serialNumber,
            items[seriesId][serialNumber].passphrase,
            items[seriesId][serialNumber].owner
       ); 
    }

    // function setFirstOwner(uint256 _passphrase) public {
        
    //     require(owner == address(0));
    //     require(_passphrase == passphrase);

    //     new Ownable();
    // }
}
