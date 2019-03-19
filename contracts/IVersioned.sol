pragma solidity ^0.5.2;

/**
 * @title IVersioned interface
 * blockchainassetregistry.com
 */
interface IVersioned {
    event AppendedData( string data, uint256 versionIndex );

    /*
    * @dev fallback function
    */
    function() external;

    /**
    * @dev Appends data to a string[] list
    * @param _data any string. Could be an IPFS hash
    */
    function appendData(string calldata _data) external returns (bool);

    /**
    * @dev Gets the current index of the data list
    */
    function getVersionIndex() external view returns (uint count);
}
