// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import "../src/JIAM.sol";
contract CounterScript is Script {
    function run() public { 
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        JIAM Jiam = new JIAM();

        vm.stopBroadcast();
    }
}
