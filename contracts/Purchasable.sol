pragma solidity ^0.4.24;

import 'node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol';

/**
 * @title Purchasable
 */
contract Purchasable is Ownable {

    uint256 public price = 0;
    uint256[] public priceHistory;
    address public buyer;

    event ProcessedRemainder(uint256 remainder);
    event AssetPurchased(address buyer, uint256 price);

    function() public payable {}

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
        transfer(buyer);

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