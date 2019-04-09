pragma solidity ^0.5.2;

/**
 * @title Ownable
 * @dev Extends a contract with ownership cappabilites
 */
contract Ownable {

    /**
    * @dev The current owner of the contract
    */
    address public owner;
    
    /**
    * @dev A list of the contract owners
    */
    address[] public owners;

    /**
    * @dev The pending owner. 
    * The current owner must have transferred the contract to this address
    * The pending owner must claim the ownership
    */
    address public pendingOwner;

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
        owner = msg.sender;
        owners.push(owner);
        emit OwnershipTransferred(address(0), owner);
    }

    /*
    * @dev fallback function
    */
    function() external {}

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == owner;
    }
    
    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isPendingOwner() public view returns (bool) {
        return msg.sender == pendingOwner;
    }

    /**
    * @dev Allows the current owner to set the pendingOwner address.
    * @param _pendingOwner The address to transfer ownership to.
    */
    function transferOwnership(address _pendingOwner) onlyOwner public {
        pendingOwner = _pendingOwner;
        emit PendingTransfer(owner, pendingOwner);
    }


    /**
    * @dev Allows an approved trustee to set the pendingOwner address.
    * @param _pendingOwner The address to transfer ownership to.
    */
    function transferOwnershipFrom(address _pendingOwner) public {
        require(allowance(msg.sender));
        pendingOwner = _pendingOwner;
        emit PendingTransfer(owner, pendingOwner);
    }

    /**
    * @dev Allows the pendingOwner address to finalize the transfer.
    */
    function claimOwnership() onlyPendingOwner public {
        owner = pendingOwner;
        owners.push(owner);
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
