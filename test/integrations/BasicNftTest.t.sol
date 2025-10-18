// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";
import {BasicNft} from "../../src/BasicNft.sol";

contract BasicNftTest is Test {
    BasicNft public basicNft;
    DeployBasicNft public deployer;
    address public USER = makeAddr("user");
    string public constant SHEEP =
        "ipfs://bafybeihn363pz6ftzdmtgcx6guxnfdoitx4mhoffznyf77fotpiwthmeye.ipfs.dweb.link?filename=sheep.json";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "SheepFarm";
        string memory actualName = basicNft.name();
        // assert(expectedName == actualName);
        assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName)));
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNft.mintNft(SHEEP);

        assert(basicNft.balanceOf(USER) == 1);
        assert(keccak256(abi.encodePacked(SHEEP)) == keccak256(abi.encodePacked(basicNft.tokenURI(0))));
    }

    // function testCanMintAndHaveCorrectTokenURI() public {
    //     basicNft.mintNft(TOKEN_URL);
    //     assertEq(basicNft.tokenURI(0), TOKEN_URL);
    // }
}
