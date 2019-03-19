pragma solidity ^0.5.2;

import "node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";

/**
 * @title MasterRegistry
 * @dev indexes AssetRegistry* contracts
 */
contract MasterRegistry is Ownable {

    mapping (bytes32 => address) public registries;
    
    event RegisteredContract( 
        address indexed owner,
        address indexed registry 
    );

    /*
    * @dev fallback function
    */
    function() external {}

    /**
    * @dev Add data to the _data array
    * @param _name bytes32 the name of the contract
    * @param _contract the contract address
    */
    function registerContract(
        bytes32 _name, 
        address _contract
    ) onlyOwner public returns (bool) {
        registries[_name] = _contract;
        emit RegisteredContract(msg.sender, _contract);
        return true;
    }
}
