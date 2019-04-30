pragma solidity ^0.5.2;

import "./Versioned.sol";
import "./Ownable.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";

/**
 * @title vRC20
 * @dev Register whatever you own in the Ethereum blockchain
 * blockchainassetregistry.com
 */
contract vRC20 is ERC20, ERC20Detailed, Versioned, Ownable {

    constructor (
        uint256 supply,
        string memory name,
        string memory symbol,
        uint8 decimals
    ) public ERC20Detailed (name, symbol, decimals) {
        _mint(msg.sender, supply);
    }

    /**
    * @dev Add data to the _data array
    * @param _data string data
    */
    function appendData(string memory _data) public onlyOwner returns (bool) {
        return _appendData(_data);
    }
}
