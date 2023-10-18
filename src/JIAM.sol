// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract JIAM is ERC20, ERC20Permit {
    mapping(address => bool) public allowedUsers;
    mapping(address => uint8) public userTier;

    modifier onlyAllowedUsers() {
        require(allowedUsers[msg.sender], "User not allowed");
        _;
    }
    constructor() ERC20("Jian", "JAN") ERC20Permit("Jian") {
        allowedUsers[msg.sender]= true;
        _mint(msg.sender, 1000000 * 10 ** uint256(decimals()));
    }

    function addToAllowlist(address user, uint8 tier) external onlyAllowedUsers {
        allowedUsers[user] = true;
        userTier[user] = tier;
    }

    function getToken(uint256 amount) external payable {
        require(msg.value >= amount, "Insufficient ETH sent");
        _mint(msg.sender, amount);
        _transfer(address(this), msg.sender, amount);
    }

    function multiLevelDistribution(address[] memory recipients, uint256[] memory amounts, uint8 tier) external onlyAllowedUsers {
        require(recipients.length == amounts.length, "Arrays length mismatch");

        for (uint256 i = 0; i < recipients.length; i++) {
            require(userTier[recipients[i]] == tier, "Recipient not in specified tier");
            _mint(recipients[i], amounts[i]);
        }
    }
    
    function airDrop(address[] memory recipients, uint256 amount) external onlyAllowedUsers {
        for (uint256 i = 0; i < recipients.length; i++) {
            _mint(recipients[i], amount);
        }
    }

    function mintAndSend(address recipient, uint256 amount) external onlyAllowedUsers {
        _mint(recipient, amount);
    }
}
