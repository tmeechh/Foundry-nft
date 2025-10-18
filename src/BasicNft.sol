// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIdToUrl;

    constructor() ERC721("SheepFarm", "SHEEP") {
        s_tokenCounter = 0;
    }

    function mintNft(string memory tokenUrl) public {
        s_tokenIdToUrl[s_tokenCounter] = tokenUrl;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return s_tokenIdToUrl[tokenId];
    }

    // function getTokenCounter() public view returns (uint256) {
    //     return s_tokenCounter;
    // }
}
