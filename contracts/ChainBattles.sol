// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter; 

    Counters.Counter private _tokenIds;
    struct stats {
        uint256 level;
        uint256 speed;
        uint256 strength;
        uint256 life;
    }
    mapping(uint256 => stats) public tokenIdToLevels;

    constructor() ERC721 ("Chain Battles", "CBTLS") {
    }

    function generateCharacter(uint256 tokenId) public returns(string memory){
        (string memory level, string memory speed, string memory strength, string memory life) = getAttributes(tokenId);
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",level, '</text>',
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed: ",speed, '</text>',
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength: ",strength, '</text>',
            '<text x="50%" y="80%" class="base" dominant-baseline="middle" text-anchor="middle">', "Life: ",life, '</text>',
            '</svg>'
        );
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
                )    
            );
    }

    function getAttributes(uint256 tokenId) public view returns (string memory, string memory, string memory, string memory) {
        uint256 levels = tokenIdToLevels[tokenId].level;
        uint256 speed = tokenIdToLevels[tokenId].speed;
        uint256 strength = tokenIdToLevels[tokenId].strength;
        uint256 life = tokenIdToLevels[tokenId].life;

        return (levels.toString(), speed.toString(), strength.toString(), life.toString());
    }

    function getTokenURI(uint256 tokenId) public returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "Chain Battles #', tokenId.toString(), '",',
                '"description": "Battles on chain",',
                '"image": "', generateCharacter(tokenId), '"',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);

        tokenIdToLevels[newItemId].level = 0;
        tokenIdToLevels[newItemId].speed = (uint (keccak256(
            abi.encodePacked(block.timestamp + 1)
        ))  % 100 );
        tokenIdToLevels[newItemId].strength = (uint (keccak256(
            abi.encodePacked(block.timestamp + 2)
        ))  % 100 );
        tokenIdToLevels[newItemId].life = (uint (keccak256(
            abi.encodePacked(block.timestamp + 3)
        ))  % 100 );

        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId));
        require(ownerOf(tokenId) == msg.sender, "You must own this NFT to train it!");

        tokenIdToLevels[tokenId].level ++;
        tokenIdToLevels[tokenId].speed ++;
        tokenIdToLevels[tokenId].strength ++;
        tokenIdToLevels[tokenId].life ++;

        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}