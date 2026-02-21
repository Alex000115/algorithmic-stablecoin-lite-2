// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IStableToken is IERC20 {
    function mint(address to, uint256 amount) external;
    function burnFrom(address account, uint256 amount) external;
}

contract Treasury is Ownable {
    IStableToken public cash;
    address public oracle;
    uint256 public constant TARGET_PRICE = 1e18; // $1.00
    uint256 public epochDuration = 24 hours;
    uint256 public lastEpochTime;

    event SupplyExpanded(uint256 amountMinted);
    event SupplyContracted(uint256 amountBurned);

    constructor(address _cash, address _oracle) Ownable(msg.sender) {
        cash = IStableToken(_cash);
        oracle = _oracle;
        lastEpochTime = block.timestamp;
    }

    function getPrice() public view returns (uint256) {
        // In production, fetch from Chainlink/Uniswap Oracle
        return TARGET_PRICE; 
    }

    function allocateSeigniorage() external {
        require(block.timestamp >= lastEpochTime + epochDuration, "Epoch not reached");
        uint256 currentPrice = getPrice();

        if (currentPrice > TARGET_PRICE + (TARGET_PRICE / 20)) { // > $1.05
            uint256 amountToMint = (cash.totalSupply() * (currentPrice - TARGET_PRICE)) / TARGET_PRICE;
            cash.mint(address(this), amountToMint);
            // logic to distribute to Share stakers...
            emit SupplyExpanded(amountToMint);
        }
        
        lastEpochTime = block.timestamp;
    }
}
