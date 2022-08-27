// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "./EimerPunksDNA.sol";

contract EimerPunks is ERC721, ERC721Enumerable, EimerPunksDNA {
    using Counters for Counters.Counter;

    string private constant AVATAAARS_BASE_URL = "https://avataaars.io/";

    Counters.Counter private _tokenIdCounter;
    uint256 public maxSupply;
    mapping(uint256 => uint256) public tokenDNA;

    constructor(uint256 _maxSupply) ERC721("EimerPunks", "PLPKS") {
        maxSupply = _maxSupply;
    }

    function safeMint() public {
        uint256 currentTokenId = _tokenIdCounter.current();
        require(currentTokenId < maxSupply, "No EimerPunks left :(");
        _tokenIdCounter.increment();
        tokenDNA[currentTokenId] = deterministicPseudoRandomDNA(
            currentTokenId,
            msg.sender
        );
        _safeMint(msg.sender, currentTokenId);
    }

    function _baseURI() internal pure override returns (string memory) {
        return AVATAAARS_BASE_URL;
    }

    function _paramsURI(uint256 _dna) internal view returns (string memory) {
        string memory params;

        {
            params = string(
                abi.encode(
                    "accessoriesType=",
                    getAccessoriesType(_dna),
                    "&clotheColor=",
                    getClotheColor(_dna),
                    "&clotheType=",
                    getClotheType(_dna),
                    "&eyeType=",
                    getEyeType(_dna),
                    "&eyebrowType=",
                    getEyeBrowType(_dna),
                    "&facialHairColor=",
                    getFacialHairColor(_dna),
                    "&facialHairType=",
                    getFacialHairType(_dna),
                    "&hairColor=",
                    getHairColor(_dna),
                    "&hatColor=",
                    getHatColor(_dna),
                    "&graphicType=",
                    getGraphicType(_dna),
                    "&mouthType=",
                    getMouthType(_dna),
                    "&skinColor=",
                    getSkinColor(_dna)
                )
            );
        }

        return string(abi.encodePacked(params, "&topType=", getTopType(_dna)));
    }

    function imageByDNA(uint256 _dna) public view returns (string memory) {
        string memory baseURI = _baseURI();
        string memory paramsURI = _paramsURI(_dna);
        return string(abi.encodePacked(baseURI, "?", paramsURI));
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

        uint256 dna = tokenDNA[_tokenId];
        string memory image = imageByDNA(dna);

        string memory jsonURI = Base64.encode(
            abi.encodePacked(
                '{ "name": "EimerPunks #',
                _tokenId,
                '"',
                '"description:": "Eimer Punks are randomized Avataaars stored on chain to teach DApp development on Eimer"',
                '"image": "',
                image,
                '"',
                "}"
            )
        );
        return
            string(abi.encodePacked("data:application/json;base64", jsonURI));
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
