// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract PlatziPunks is ERC721, ERC721Enumerable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint256 public maxSupply;

    constructor(uint256 _maxSupply) ERC721("PlatziPunks", "PLPKS") {
        maxSupply = _maxSupply;
    }

    function safeMint() public {
        uint256 currentTokenId = _tokenIdCounter.current();
        require(currentTokenId < maxSupply, "No PlatziPunks left :(");
        _tokenIdCounter.increment();
        _safeMint(msg.sender, currentTokenId);
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(
            _exists(_tokenId),
            "ERC721 Metadata: URI query for nonexisting token."
        );
        string memory jsonURI = Base64.encode(
            abi.encodePacked(
                '{ "name": "PlatziPunks #', _tokenId, '"',
                '"description:": "Platzi Punks are randomized Avataaars stored on chain to teach DApp development on Platzi"',
                '"image": "TODO: Calculate image URL"',
                '}'
                )
            );
        return string(abi.encodePacked("data:application/json;base64", jsonURI));
    }

    // Override required
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
