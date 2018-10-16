pragma solidity ^0.4.24;

/**
 * @title Asset
 * @dev The Asset contract has an owner who can transfer the ownership of the asset
 * an Asset contract is tracked via an AssetSeries contract
 */
contract Asset {

    address public owner;
    address public lastOwner;
    address public pendingOwner;
    string public description;
    mapping (address => mapping (address => bool)) internal allowed;

    event AssetDestroyed(address indexed lastOwner);
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
    constructor(address _owner, string _description) public {
        owner = _owner;
        description = _description;
    }

    /*
    * @dev fallback function
    */
    function() public {}

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
    * @dev The Asset is no longer active
    */
    function destroy() onlyOwner public {
        lastOwner = owner;
        owner = address(0);
        emit AssetDestroyed(lastOwner);
        selfdestruct(lastOwner);
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
