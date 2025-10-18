// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
// import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract MintMoodNft is Script {


    function run() external {
         address mostRecentlyDeployed = 0xBA1065cd427e22c6b9Be49aB519F27B3B5fB444a; 
        // address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("MoodNft", block.chainid);
        mintMoodNftOnContract(mostRecentlyDeployed);
    }

    function mintMoodNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        MoodNft(contractAddress).mintNft();
        vm.stopBroadcast();
    }
}

contract FlipMoodNft is Script {
    function run() external {
       address mostRecentlyDeployed = 0xBA1065cd427e22c6b9Be49aB519F27B3B5fB444a; 
        // address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("MoodNft", block.chainid);
        flipMoodOnContract(mostRecentlyDeployed, 0); // tokenId = 0 (you can change)
    }

    function flipMoodOnContract(address contractAddress, uint256 tokenId) public {
        vm.startBroadcast();
        MoodNft(contractAddress).flipMood(tokenId);
        vm.stopBroadcast();
    }
}

contract MintBasicNft is Script {
    string public constant SHEEP =
        "ipfs://bafybeihl35bco6tsfii32t6cefcctgla3isytyqjlhoiwf276wm3tevslq.ipfs.dweb.link?filename=sheep.json";

    function run() external {
        // address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("BasicNft", block.chainid);
        address mostRecentlyDeployed = 0xBA5599Ba5e3b24dED8e78A7CebE8d617f8B471E7;
        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNft(contractAddress).mintNft(SHEEP);
        vm.stopBroadcast();
    }
}
