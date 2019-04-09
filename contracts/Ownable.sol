pragma solidity ^0.5.2;

/**
 * @title Ownable
 * @dev Extends a contract with ownership cappabilites
 */
contract Ownable {

    /**
    * @dev The current owner of the contract
    */
    address private _owner;
    
    /**
    * @dev A list of the contract owners
    */
    address[] private _owners;

    /**
    * @dev The pending owner. 
    * The current owner must have transferred the contract to this address
    * The pending owner must claim the ownership
    */
    address private _pendingOwner;

    /**
    * @dev A list of addresses that are allowed to transfer 
    * the contract ownership on behalf of the current owner
    */
    mapping (address => mapping (address => bool)) internal allowed;

    event PendingTransfer( address indexed owner, address indexed pendingOwner );
    event OwnershipTransferred( address indexed previousOwner, address indexed newOwner );
    event Approval( address indexed owner, address indexed trustee );
    event RemovedApproval( address indexed owner, address indexed trustee );

    /**
    * @dev Modifier throws if called by any account other than the pendingOwner.
    */
    modifier onlyPendingOwner {
        require(isPendingOwner());
        _;
    }

    /**
    * @dev Throws if called by any account other than the owner.
    */
    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    /**
    * @dev The Asset constructor sets the original `owner` 
    * of the contract to the sender account.
    */
    constructor() public {
        _owner = msg.sender;
        _owners.push(_owner);
        emit OwnershipTransferred(address(0), _owner);
    }

    /*
    * @dev fallback function
    */
    function() external {}

    /**
     * @return the set asset owner
     */
    function owner() public view returns (address owner) {
        return _owner;
    }
    
    /**
     * @return the set asset owner
     */
    function owners() public view returns (address[] owners) {
        return _owners;
    }
    
    /**
     * @return the set asset pendingOwner
     */
    function pendingOwner() public view returns (address pendingOwner) {
        return _pendingOwner;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }
    
    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isPendingOwner() public view returns (bool) {
        return msg.sender == _pendingOwner;
    }

    /**
    * @dev Allows the current owner to set the pendingOwner address.
    * @param pendingOwner The address to transfer ownership to.
    */
    function transferOwnership(address pendingOwner) onlyOwner public {
        _pendingOwner = pendingOwner;
        emit PendingTransfer(_owner, _pendingOwner);
    }


    /**
    * @dev Allows an approved trustee to set the pendingOwner address.
    * @param pendingOwner The address to transfer ownership to.
    */
    function transferOwnershipFrom(address pendingOwner) public {
        require(allowance(msg.sender));
        _pendingOwner = pendingOwner;
        emit PendingTransfer(_owner, _pendingOwner);
    }

    /**
    * @dev Allows the pendingOwner address to finalize the transfer.
    */
    function claimOwnership() onlyPendingOwner public {
        _owner = _pendingOwner;
        _owners.push(_owner);
        _pendingOwner = address(0);
        emit OwnershipTransferred(_owner, _pendingOwner);
    }

    /**
    * @dev Approve the passed address to transfer the Asset on behalf of msg.sender.
    * @param trustee The address which will spend the funds.
    */
    function approve(address trustee) onlyOwner public returns (bool) {
        allowed[msg.sender][trustee] = true;
        emit Approval(msg.sender, trustee);
        return true;
    }

    /**
    * @dev Approve the passed address to transfer the Asset on behalf of msg.sender.
    * @param trustee The address which will spend the funds.
    */
    function removeApproval(address trustee) onlyOwner public returns (bool) {
        allowed[msg.sender][trustee] = false;
        emit RemovedApproval(msg.sender, trustee);
        return true;
    }

    /**
    * @dev Function to check if a trustee is allowed to transfer on behalf the owner
    * @param trustee address The address which will spend the funds.
    * @return A bool specifying if the trustee can still transfer the Asset
    */
    function allowance(address trustee) public view returns (bool) {
        return allowed[_owner][trustee];
    }
}
