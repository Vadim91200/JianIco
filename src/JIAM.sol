// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract JIAM is ERC20, ERC20Permit {
    mapping(address => bool) public allowedUsers;
    enum Tier {One, Two, Three}
    mapping(address => Tier) public userTiers;

    modifier onlyAllowedUsers() {
        require(allowedUsers[msg.sender], "User not allowed");
        _;
    }
    constructor() ERC20("Jian", "JAN") ERC20Permit("Jian") {
        allowedUsers[msg.sender] = true;
        _mint(msg.sender, 1000000 * 10 ** uint256(decimals()));
    }

    function addToAllowlist(address user, Tier tier) external onlyAllowedUsers {
        allowedUsers[user] = true;
        userTiers[user] = tier;
    }

    function getToken(uint256 amount) external payable onlyAllowedUsers{
        require(msg.value >= amount, "Insufficient ETH sent");
        _mint(msg.sender, amount);
    }

    function multiLevelDistribution(address[] calldata recipients) external payable onlyAllowedUsers {
        for (uint256 i = 0; i < recipients.length; i++) {
            uint256 nbrOfTokensToMint;
            Tier userTier = userTiers[recipients[i]];
            if (userTier == Tier.One) {
                nbrOfTokensToMint = msg.value * 1 * 10 ** uint256(decimals());
            } else if (userTier == Tier.Two) {
                nbrOfTokensToMint = msg.value * 2 * 10 ** uint256(decimals());
            } else if (userTier == Tier.Three) {
                nbrOfTokensToMint = msg.value * 3 * 10 ** uint256(decimals());
            } else {
                revert("You are not allowed to call this function.");
            }
            _mint(msg.sender, nbrOfTokensToMint);
        }
    }
    
    function airDrop(address[] calldata recipients, uint256 amount) external onlyAllowedUsers {
        for (uint256 i = 0; i < recipients.length; i++) {
            _mint(recipients[i], amount);
        }
    }
}
