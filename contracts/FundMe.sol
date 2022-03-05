// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe  {
    
    //no longer need for >=0.8v of solidity
    using SafeMathChainlink for uint256;
    address public owner;

    mapping(address=> uint256) public addressToAmountFunded;

    address[] public funders;

    constructor() public {
        owner = msg.sender;
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
   
    (,int256 answer,,,) = priceFeed.latestRoundData();

    return uint256(answer *  10000000000);
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        return (ethAmount * getPrice()) / 1000000000000000000;
    }

    function deposit() public payable {
        uint256 minimumUSD = 50 * 10 ** 18;
        require(getConversionRate(msg.value) >= minimumUSD, "you need to spend more ETH!");
        addressToAmountFunded[msg.sender] += msg.value;

        funders.push(msg.sender);
    }

    function withdraw()payable onlyOwner public {
        msg.sender.transfer(address(this).balance);

        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Contract Owner can withdraw");
        _;
    }
}
