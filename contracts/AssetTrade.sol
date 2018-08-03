pragma solidity ^0.4.24;

import 'node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol';
import './Asset.sol';

/**
 * @title Asset
 * @dev The Asset contract has an owner who can transfer the ownership of the asset
 * an Asset contract is tracked via an AssetSeries contract
 */
contract AssetTrade {

    using SafeMath for uint256;

    modifier onlyOwner() {
        require(msg.sender == asset.owner);
        _;
    }
    
    modifier canBuy() {
        require(state != State.Paused);
        require(price > 0, 'Asset must have a price in order to be purchased');
        require(msg.value > 0, 'Input value must be greater than 0');
        require(msg.value >= price, 'Input value must be gte than price');
        _;
    }
    
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

    /*
    * @dev
    */
    function() public payable {
        buy();
    }

    /*
    * @dev
    */
    function pause() public onlyOwner {
        state = State.Paused;
    }

    /*
    * @dev
    */
    function sellTo(uint256 _price, address _buyer) public onlyOwner {
        require(_price > 0);
        require(_buyer != address(0));

        state = State.SellingTo

        price = _price;
        buyer = _buyer;
    }

    /*
    * @dev
    */
    function sell(uint256 _price) public onlyOwner {
        require(_price > 0);

        state = State.OpenSale

        buyer = address(0);
        price = _price;
    }

    /*
    * @dev
    */
    function buyFrom() canBuy public payable {
        require(state == State.SellingTo);
        require(buyer == msg.sender);
        _processPurchase();
    }

    /*
    * @dev
    */
    function buy() canBuy public payable {
        require(state == State.OpenSale);
        _processPurchase();
    }

    /*
    * @dev Executes the actual purchase by
    * 1. processing the remainder
    * 2. Transferring the price to the current owner
    * 3. Adding the buyer to the 
    */
    function _processPurchase() internal {
        _processRemainder();
        asset.owner.transfer(price);
        asset.transferFrom(msg.sender);
        emit AssetPurchased(msg.sender, price);
        buyers.push(msg.sender);
        priceHistory.push(price);
        price = 0;
        buyer = address(0);
    }

    /**
    * @dev Transfers back the remainder of the weiAmount against the token price to the beneficiary
    * @return price Value without the remainder
    */
    function _processRemainder() internal {
        uint256 remainder = msg.value % price;

        if (remainder > 0) {
            msg.sender.transfer(remainder);
            emit ProcessedRemainder(remainder);
        }

        price.sub(remainder);
    }
}