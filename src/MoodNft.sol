// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";


contract MoodNft is ERC721 {
    // errors
    error MoodNft__CantFlipMoodIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_calmSvgImageUri;
    string private s_crazySvgImageUri;

    enum Mood {
        CALM,
        CRAZY
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(string memory crazySvgImageUri, string memory calmSvgImageUri) ERC721("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_calmSvgImageUri = calmSvgImageUri;
        s_crazySvgImageUri = crazySvgImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.CALM;
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        // only want the nft owner to be avle to change the mood
        address owner = ownerOf(tokenId);
        if (!_isAuthorized(owner, msg.sender, tokenId)) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }
        if (s_tokenIdToMood[tokenId] == Mood.CALM) {
            s_tokenIdToMood[tokenId] = Mood.CRAZY;
        } else {
            s_tokenIdToMood[tokenId] = Mood.CALM;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdToMood[tokenId] == Mood.CALM) {
            imageURI = s_calmSvgImageUri;
        } else {
            imageURI = s_crazySvgImageUri;
        }

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "',
                            name(),
                            '", "description": "An NFT that reflect the owners mood.", "attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );
    }

        //  Updated: Return plain UTF-8 JSON (not Base64 JSON)
    // function tokenURI(uint256 tokenId) public view override returns (string memory) {
    //     string memory imageURI = s_tokenIdToMood[tokenId] == Mood.CALM
    //         ? s_calmSvgImageUri
    //         : s_crazySvgImageUri;

    //     string memory json = string(
    //         abi.encodePacked(
    //             '{"name": "',
    //             name(),
    //             ' #',
    //             Strings.toString(tokenId),
    //             '", "description": "An NFT that reflects the owner\'s mood.", ',
    //             '"attributes": [{"trait_type": "moodiness", "value": 100}], ',
    //             '"image": "data:image/svg+xml;base64,',
    //             Base64.encode(bytes(imageURI)),
    //             '"}'
    //         )
    //     );

    //     return string.concat(_baseURI(), json);
    // }

    // Comparing enum directly

    function getMood(uint256 tokenId) public view returns (Mood) {
        return s_tokenIdToMood[tokenId];
    }
}
