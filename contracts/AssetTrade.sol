pragma solidity ^0.4.24;

import 'node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol';
import './Asset.sol';

/**
 * @title Asset
 * @dev The Asset contract has an owner who can transfer the ownership of the asset
 * an Asset contract is tracked via an AssetSeries contract
 */

contract AssetTrade {

    modifier onlyOwner() {
        require(msg.sender == asset.owner);
        _;
    }

    using SafeMath for uint256;
    
    enum State { SellingTo, OpenSale, Paused }
    State public state;

    Asset public asset;

    uint256 public price = 0;
    uint256[] public priceHistory;

    address public buyer;
    address[] public buyers;

    event ProcessedRemainder(uint256 remainder);
    event AssetPurchased(address indexed buyer, uint256 price);

    constructor(Asset _asset) public onlyOwner {
        asset = _asset;
    }

    function() public payable {
        buy();
    }

    function pause() public onlyOwner {
        state = State.Paused;
    }

    function sellTo(uint256 _price, address _buyer) public onlyOwner {
        require(_price > 0);
        require(_buyer != address(0));

        state = State.SellingTo

        price = _price;
        buyer = _buyer;
    }

    function sell(uint256 _price) public onlyOwner {
        require(_price > 0);

        state = State.OpenSale

        buyer = address(0);
        price = _price;
    }

    function buy() public payable {
        if (state == State.Paused) {
            revert();
        }

        require(price > 0, 'Asset must have a price in order to be purchased');
        require(msg.value > 0, 'Input value must be greater than 0');
        require(msg.value >= price, 'Input value must be gte than price');

        if (state == State.SellingTo) {
            require(buyer == msg.sender);
            _buy(buyer);
        } else {
            _buy(msg.sender);
        }
    }

    function _buy(address _buyer) internal {
        uint256 _price = _processRemainder(_buyer);
        asset.owner.transfer(_price);
        priceHistory.push(_price);
        
        buyers.push(_buyer);
        emit AssetPurchased(_buyer, _price);
        
        asset.transferOwnership(_buyer);

        price = 0;
        buyer = address(0);
    }

    /**
       * @dev Transfers back the remainder of the weiAmount against the token price to the beneficiary
       * @return price Value without the remainder
    */
    function _processRemainder(address _buyer) internal returns (uint256) {
        uint256 remainder = msg.value % price;

        if (remainder > 0) {
            _buyer.transfer(remainder);
            emit ProcessedRemainder(remainder);
        }

        return price.sub(remainder);
    }
}