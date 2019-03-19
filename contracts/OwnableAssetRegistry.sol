pragma solidity ^0.5.2;

import "./IRegistry.sol";
import "./OwnableAsset.sol";

/**
 * @title OwnableAssetRegistry
 * @dev creates and indexes OwnableAsset contracts
 */
contract OwnableAssetRegistry is IRegistry {

    OwnableAsset[] public assets;
    
    event CreatedAsset( 
        address issuer,
        OwnableAsset asset 
    );

    /*
    * @dev fallback function
    */
    function() external {}

    /**
    * @dev Add data to the _data array
    * @param _data string data
    */
    function newAsset(string memory _data) public returns (address) {
        OwnableAsset asset = new OwnableAsset();
        assets.push(asset);
        asset.appendData(_data);
        asset.transferOwnership(msg.sender);
        emit CreatedAsset(msg.sender, asset);
        return address(asset);
    }

    /**
    * @dev Gets the current index of the assets list
    */
    function getAssetsCount() public view returns (uint count) {
        return assets.length - 1;
    }
}
