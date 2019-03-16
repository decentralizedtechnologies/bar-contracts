pragma solidity ^0.5.2;

/**
 * @title IAsset interface
 * @dev The Asset contract has an owner who can transfer the ownership of the asset
 * an Asset contract is tracked via an AssetSeries contract
 */
interface IAsset {
    event AssetDestroyed(address indexed lastOwner);
    event PendingTransfer( address indexed owner, address indexed pendingOwner );
    event OwnershipTransferred( address indexed previousOwner, address indexed newOwner );
    event Approval( address indexed owner, address indexed trustee );
    event RemovedApproval( address indexed owner, address indexed trustee );
    event AppendedData( address indexed owner, bytes32 indexed data );

    /*
    * @dev fallback function
    */
    function() external;

    function appendData(bytes32 _data) external returns (bool);

    /**
    * @dev Allows the current owner to set the pendingOwner address.
    * @param newOwner The address to transfer ownership to.
    */
    function transfer(address newOwner) external;


    /**
    * @dev Allows an approved trustee to set the pendingOwner address.
    * @param newOwner The address to transfer ownership to.
    */
    function transferFrom(address newOwner) external;

    /**
    * @dev Allows the pendingOwner address to finalize the transfer.
    */
    function claim() external;

    /**
    * @dev Approve the passed address to transfer the Asset on behalf of msg.sender.
    * @param _trustee The address which will spend the funds.
    */
    function approve(address _trustee) external returns (bool);

    /**
    * @dev Approve the passed address to transfer the Asset on behalf of msg.sender.
    * @param _trustee The address which will spend the funds.
    */
    function removeApproval(address _trustee) external returns (bool);

    /**
    * @dev Function to check if a trustee is allowed to transfer on behalf the owner
    * @param _trustee address The address which will spend the funds.
    * @return A bool specifying if the trustee can still transfer the Asset
    */
    function allowance(address _trustee) external view returns (bool);
}
