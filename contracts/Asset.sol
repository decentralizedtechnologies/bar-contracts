pragma solidity ^0.4.24;

import 'node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol';
import 'node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol';

/**
 * @title Asset
 * @dev The Asset contract has an owner who can transfer the ownership of the asset
 * an Asset contract is tracked via an AssetSeries contract
 */
contract Asset is Ownable {

    using SafeMath for uint256;

    address[] public owners;
    address public pendingOwner;
    uint256 public price = 0;
    uint256[] public priceHistory;
    address public buyer;

    event ProcessedRemainder(uint256 remainder);
    event AssetPurchased(address buyer, uint256 price);
    event PendingOwnership(
        address indexed owner,
        address indexed pendingOwner);

    constructor() public Ownable() {
        owners.push(msg.sender);
    }

    function() public payable {}

    /**
     * Only the owner can transfer this Asset
     * An Asset must be claimed to complete the ownership transfer
     */
    function transferTo(address _newOwner) public onlyOwner {
        pendingOwner = _newOwner;
        emit PendingOwnership(owner, pendingOwner);
    }

    /**
     * An asset can be claimed only if the owner has transfered the asset to the msg.sender
     * The sender must claim ownership of the Asset
     */
    function claim() public {
        require(msg.sender == pendingOwner, 'Asset cannot be accepted');
        transferOwnership(msg.sender);
        owners.push(owner);
    }

    function sellTo(uint256 _price, address _buyer) public onlyOwner {
        require(_price > 0);
        require(_buyer != address(0));

        price = _price;
        buyer = _buyer;
    }

    function sell(uint256 _price) public onlyOwner {
        require(_price > 0);

        buyer = address(0);
        price = _price;
    }

    function buy() public payable {
        require(msg.value > 0);
        require(msg.value == price);

        buyer = msg.sender;
        require(buyer != address(0));

        uint256 _price = _processRemainder();
        owner.transfer(_price);
        priceHistory.push(_price);
        transferTo(buyer);

        emit AssetPurchased(buyer, _price);
    }

    /**
       * @dev Transfers back the remainder of the weiAmount against the token price to the beneficiary
       * @return price Value without the remainder
    */
    function _processRemainder() internal returns (uint256) {
        uint256 remainder = msg.value % price;

        if (remainder > 0) {
            msg.sender.transfer(remainder);
            emit ProcessedRemainder(remainder);
        }

        return price.sub(remainder);
    }
}