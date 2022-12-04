// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "hardhat/console.sol";

contract NFTReward is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    event NFTRewardMinted(address sender, uint256 tokenId);

    constructor() ERC721("WeFunder", "WFR") {}

    function MintNFTReward(address to, string memory title) internal {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        console.log(getTokenURI(title));
        _setTokenURI(tokenId, getTokenURI(title));
        emit NFTRewardMinted(msg.sender, tokenId);
    }

    function getTokenURI(string memory title) pure internal returns (string memory) {
        string memory baseSVG = "<svg viewBox='24.562 55.263 465.789 385.088' xmlns='http://www.w3.org/2000/svg' xmlns:bx='https://boxy-svg.com'>"
        "<defs><style bx:fonts='Annie Use Your Telescope'>@import url(https://fonts.googleapis.com/css2?family=Annie+Use+Your+Telescope%3Aital%2Cwght%400%2C400&amp;display=swap);</style>"
        "</defs><path d='M 405 149.005 L 442.911 225.82 L 527.682 238.138 L 466.341 297.931 L 480.821 382.359 L 405 342.498 L 329.179 382.359 L 343.659 297.931 L 282.318 238.138 L 367.089 225.82 Z' style='stroke: rgb(0, 0, 0); fill: rgb(253, 170, 28);' transform='matrix(0.306009, -0.952029, 0.952029, 0.306009, -153.509715, 492.606148)' bx:shape='star 405 278 128.995 128.995 0.5 5 1@48bd181d'/>"
        "<text style='fill: rgb(51, 51, 51); font-family: Arial, sans-serif; font-size: 24.6px; word-spacing: 1px; white-space: pre;' transform='matrix(1, 0, 0, 1, -15.789474, 11.403509)'><tspan x='81.579' y='365.789' style='font-size: 22.6px;'>      </tspan><tspan style='font-family: &quot;Annie Use Your Telescope&quot;; font-size: 27px; font-weight: 700;'>You're A Gold Star Donor!</tspan><tspan x='81.579' dy='1.2em'></tspan><tspan style='font-size: 22.6px;'>Thank For Your Donation To </tspan><tspan style='font-size: 21.6px;'>";

        string memory endSVG = "</tspan></text><path d='M 340 168.895 L 364.718 218.979 L 419.989 227.01 L 379.994 265.995 L 389.436 321.042 L 340 295.053 L 290.564 321.042 L 300.006 265.995 L 260.011 227.01 L 315.282 218.979 Z' style='stroke: rgb(0, 0, 0); fill: rgb(208, 236, 230);' transform='matrix(0.281602, -0.959531, 0.959531, 0.281602, -102.541186, 447.977978)' bx:shape='star 340 253 84.105 84.105 0.5 5 1@0a1c4071'/>"
        "<rect x='25.439' y='52.632' width='464.912' height='388.597' style='stroke: rgb(0, 0, 0); fill: rgba(5, 0, 0, 0.09);'/></svg>";

        string memory finalSVG = Base64.encode(abi.encodePacked(baseSVG, title, endSVG));
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "WeFunder Donor Token",',
                '"description": "Token To Show That You Are a WeFunder Donor",',
                '"image": "data:image/svg+xml;base64,',finalSVG, '"',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }
}