pragma solidity ^0.5.2;

import "./IAsset.sol";

/**
 * @title Asset
 * @dev The Asset contract has an owner who can transfer the ownership of the asset
 * an Asset contract is tracked via an AssetSeries contract
 */
contract Asset is IAsset {

    address public owner;
    address public lastOwner;
    address public pendingOwner;
    bytes32[] public data;
    mapping (address => mapping (address => bool)) internal allowed;

    event PendingTransfer(
        address indexed owner,
        address indexed pendingOwner
    );
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event Approval(
        address indexed owner,
        address indexed trustee
    );
    event RemovedApproval(
        address indexed owner,
        address indexed trustee
    );
    event AppendedData(
        address indexed owner,
        bytes32 indexed data
    );

    /**
    * @dev Modifier throws if called by any account other than the pendingOwner.
    */
    modifier onlyPendingOwner {
        require(msg.sender == pendingOwner);
        _;
    }

    /**
    * @dev Throws if called by any account other than the owner.
    */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /**
    * @dev The Asset constructor sets the original `owner` of the contract to the sender
    * account.
    */
    constructor(address _owner) public {
        owner = _owner;
    }

    /*
    * @dev fallback function
    */
    function() external {}

    /**
    * @dev Add data to the _data array
    * @param _data bytes32 data
    */
    function appendData(bytes32 _data) onlyOwner public returns (bool) {
        data.push(_data);
        emit AppendedData(owner, _data);
        return true;
    }

    /**
    * @dev Allows the current owner to set the pendingOwner address.
    * @param newOwner The address to transfer ownership to.
    */
    function transfer(address newOwner) onlyOwner public {
        pendingOwner = newOwner;
        emit PendingTransfer(owner, pendingOwner);
    }


    /**
    * @dev Allows an approved trustee to set the pendingOwner address.
    * @param newOwner The address to transfer ownership to.
    */
    function transferFrom(address newOwner) public {
        require(allowance(msg.sender));
        pendingOwner = newOwner;
        emit PendingTransfer(owner, pendingOwner);
    }

    /**
    * @dev Allows the pendingOwner address to finalize the transfer.
    */
    function claim() onlyPendingOwner public {
        owner = pendingOwner;
        pendingOwner = address(0);
        emit OwnershipTransferred(owner, pendingOwner);
    }

    /**
    * @dev Approve the passed address to transfer the Asset on behalf of msg.sender.
    * @param _trustee The address which will spend the funds.
    */
    function approve(address _trustee) onlyOwner public returns (bool) {
        allowed[msg.sender][_trustee] = true;
        emit Approval(msg.sender, _trustee);
        return true;
    }

    /**
    * @dev Approve the passed address to transfer the Asset on behalf of msg.sender.
    * @param _trustee The address which will spend the funds.
    */
    function removeApproval(address _trustee) onlyOwner public returns (bool) {
        allowed[msg.sender][_trustee] = false;
        emit RemovedApproval(msg.sender, _trustee);
        return true;
    }

    /**
    * @dev Function to check if a trustee is allowed to transfer on behalf the owner
    * @param _trustee address The address which will spend the funds.
    * @return A bool specifying if the trustee can still transfer the Asset
    */
    function allowance(address _trustee) public view returns (bool) {
        return allowed[owner][_trustee];
    }
}
