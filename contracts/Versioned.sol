pragma solidity ^0.5.2;

import "./IVersioned.sol";

/**
 * @title Versioned
 * @dev Stores data of any contract
 * blockchainassetregistry.com
 */
contract Versioned is IVersioned {

    string[] public data;
    
    event AppendedData( 
        string data, 
        uint256 versionIndex
    );

    /*
    * @dev fallback function
    */
    function() external {}

    /**
    * @dev Add data to the _data array
    * @param _data string data
    */
    function appendData(string memory _data) public returns (bool) {
        data.push(_data);
        emit AppendedData(_data, getVersionIndex());
        return true;
    }

    /**
    * @dev Gets the current index of the data list
    */
    function getVersionIndex() public view returns (uint count) {
        return data.length - 1;
    }
}
