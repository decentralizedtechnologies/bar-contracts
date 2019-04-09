pragma solidity ^0.5.2;

import 'node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol';
import './Asset.sol';

/**
 * @title AssetTrade
 * @dev The AssetTrade contract takes an Asset and transfers it to a new owner in exchange of ETH
 * The AssetTrade contract must be approved to transfer the Asset after deployment
 */
contract AssetTrade {
    enum State { SellingTo, OpenSale, Paused }

    using SafeMath for uint256;

    modifier onlyOwner {
        require(msg.sender == asset.owner());
        _;
    }
    
    modifier canBuy {
        require(state != State.Paused);
        require(_price > 0, 'Asset must have a price in order to be purchased');
        require(msg.value > 0, 'Input value must be greater than 0');
        require(msg.value >= _price, 'Input value must be gte than price');
        _;
    }
    
    State private _state;

    Asset private asset;

    uint256 private _price = 0;
    uint256[] private _priceHistory;

    address private _buyer;
    address[] private _buyers;

    event ProcessedRemainder(uint256 remainder);
    event AssetPurchased(address indexed buyer, uint256 price);

    /**
    * @dev The AssetTrade constructor sets the Asset to be traded
    * After initialization, the owner MUST approve this contract to 
    * transfer the Asset ownership
    */
    constructor(Asset asset) public {
        _asset = asset;
    }

    /*
    * @dev fallback function, processes a purchase
    */
    function() public payable {
        buy();
    }

    /**
     * @return the current state of the escrow.
     */
    function state() public view returns (State) {
        return _state;
    }

    /**
     * @return the set asset price
     */
    function price() public view returns (uint256 price) {
        return _price;
    }
    
    /**
     * @return the set asset buyer
     */
    function buyer() public view returns (address buyer) {
        return _buyer;
    }
    
    /**
     * @return the set asset asset
     */
    function asset() public view returns (address asset) {
        return _asset;
    }

    /*
    * @dev Pause the sale temporarily. Call sell or sellTo to re-enable the sale
    */
    function pause() onlyOwner public {
        state = State.Paused;
    }

    /*
    * @dev Sets a buyer address
    * This method works together with buyFrom
    * If the wallet has the buyer address, then call buyFrom
    * @param price The price in WEI
    * @param buyer The buyer address
    */
    function sellTo(uint256 price, address buyer) onlyOwner public {
        require(price > 0);
        require(buyer != address(0));
        state = State.SellingTo;
        _price = price;
        _buyer = buyer;
    }

    /*
    * @dev Everyone can purchase the Asset
    * @param price The Asset price in WEI
    */
    function sell(uint256 price) onlyOwner public {
        require(price > 0);
        state = State.OpenSale;
        _buyer = address(0);
        _price = price;
    }

    /*
    * @dev If the wallet matches the buyer address set by sellTo
    * this method processes the purchase for that buyer
    * When the sale is done, the buyer still needs to claim the Asset
    */
    function buyFrom() canBuy public payable {
        require(state == State.SellingTo);
        require(_buyer == msg.sender);
        _processPurchase();
    }

    /*
    * @dev Processes the purchase for any buyer if a price has been set
    * by the current owner
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
        asset.owner().transfer(_price);
        asset.transferOwnershipFrom(msg.sender);
        emit AssetPurchased(msg.sender, _price);
        _buyers.push(msg.sender);
        priceHistory.push(_price);
        _price = 0;
        _buyer = address(0);
        pause();
    }

    /**
    * @dev Transfers back the remainder of the weiAmount against the token price to the beneficiary
    * @return price Value without the remainder
    */
    function _processRemainder() internal {
        uint256 remainder = msg.value % _price;
        if (remainder > 0) {
            msg.sender.transfer(remainder);
            emit ProcessedRemainder(remainder);
        }
        _price = _price.sub(remainder);
    }
}