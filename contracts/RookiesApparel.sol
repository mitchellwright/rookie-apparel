// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface RookieInterface {
    function ownerOf(uint256 tokenId) external view returns (address owner);
}

contract RookiesApparel is ERC721Enumerable, Ownable {
    // Active minting variables
    bool privateMintIsActive = true;
    bool publicMintIsActive = false;

    // Collection metatdata URI
    string private _baseURIExtended;

    // Rookie Contract Interface
    address public rookieAddress = 0xb1Cea9cD6B7ccBa50B30859b591076A2CFba487F;
    RookieInterface public rookieContract = RookieInterface(rookieAddress);

    constructor(string memory metadataBaseURI)
        ERC721("Rookies Apparel", "APPAREL")
    {
        _baseURIExtended = metadataBaseURI;
    }

    function flipPrivateMint() external onlyOwner {
        privateMintIsActive = !privateMintIsActive;
    }

    function flipPublicMint() external onlyOwner {
        publicMintIsActive = !publicMintIsActive;
    }

    function updateRookieContract(address _contractAddress) external onlyOwner {
        rookieAddress = _contractAddress;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIExtended;
    }

    function setBaseURI(string memory baseURI_) external onlyOwner {
        _baseURIExtended = baseURI_;
    }

    function alreadyMinted(uint256 tokenId) external view returns (bool) {
        return _exists(tokenId);
    }

    function mint(uint256 _rookieId) external {
        require(publicMintIsActive, "Public minting is not active");
        require(
            _rookieId >= 0 && _rookieId < 10000,
            "Rookie ID does not exist"
        );

        _safeMint(_msgSender(), _rookieId);
    }

    function multiMint(uint256[] memory _rookieIds) external {
        require(publicMintIsActive, "Public minting is not active");

        for (uint256 i = 0; i < _rookieIds.length; i++) {
            require(
                _rookieIds[i] >= 0 && _rookieIds[i] < 10000,
                "Rookie ID does not exist"
            );
            _safeMint(_msgSender(), _rookieIds[i]);
        }
    }

    function mintWithRookie(uint256 _rookieId) external {
        require(privateMintIsActive, "Private minting is not active");
        require(
            _rookieId >= 0 && _rookieId < 10000,
            "Rookie ID does not exist"
        );
        require(
            rookieContract.ownerOf(_rookieId) == msg.sender,
            "Not the owner of this rookie"
        );

        _safeMint(_msgSender(), _rookieId);
    }

    function multiMintWithRookie(uint256[] memory _rookieIds) external {
        require(privateMintIsActive, "Private minting is not active");

        for (uint256 i = 0; i < _rookieIds.length; i++) {
            require(
                _rookieIds[i] >= 0 && _rookieIds[i] < 10000,
                "Rookie ID does not exist"
            );
            require(
                rookieContract.ownerOf(_rookieIds[i]) == msg.sender,
                "Not the owner of this rookie"
            );
            _safeMint(_msgSender(), _rookieIds[i]);
        }
    }
}
