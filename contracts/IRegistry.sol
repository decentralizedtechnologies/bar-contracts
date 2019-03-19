pragma solidity ^0.5.2;

/**
 * @title IRegistry
 * @dev creates and indexes *Asset contracts
 */
interface IRegistry {

    event CreatedAsset( 
        address issuer,
        address asset 
    );

    /*
    * @dev fallback function
    */
    function() external;

    /**
    * @dev Add data to the _data array
    * @param _data string data
    */
    function newAsset(string calldata _data) external returns (address);

    /**
    * @dev Gets the current index of the assets list
    */
    function getAssetsCount() external view returns (uint count);
}
