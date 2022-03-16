// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract WeathlPurchase is ERC721, ERC721Enumerable, ERC721Burnable, AccessControl {
    using Counters for Counters.Counter;

    struct Purchase {
        address owner;
        uint256 amount;
        string token;
        uint256 percentage;
    }

    mapping(uint => Purchase[]) purchases;
    mapping(uint => mapping(address => uint256[])) ownedTokens;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("Weathl Purchase", "WEATHL") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function safeMint(address _mintTo, address payer, uint256 amount, string memory token, uint256 percentage, uint _poolround) public onlyRole(MINTER_ROLE) returns (uint256) {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(_mintTo, tokenId);
        purchases[tokenId].push(Purchase(payer, amount, token, percentage));
        ownedTokens[_poolround][payer].push(tokenId);
        return tokenId;
    }

    function safeBurnAndModify(address sender, uint256 tokenId) public onlyRole(MINTER_ROLE) {
        require(ownerOf(tokenId) == sender, "Invalid Owner");
        purchases[tokenId].pop();
        burn(tokenId);
    }

    function getOwnedTokens(address owner, uint _poolround) public view returns (uint256[] memory) {
        return ownedTokens[_poolround][owner];
    }

        //Get Token Percentage
     function GetTokenPercentage(string memory token, uint256 percentage) public returns (uint256){
        return (purchases[tokenId][0].percentage);
    }

    function getPurchase(uint256 tokenId) public view onlyRole(MINTER_ROLE) returns (address, uint256, string memory, uint256) {
        return (purchases[tokenId][0].owner, purchases[tokenId][0].amount, purchases[tokenId][0].token, purchases[tokenId][0].percentage);
        // return purchases[tokenId][0];
    }

    function completeClaim(uint256 tokenId, uint256 _poolround, address a) public onlyRole(MINTER_ROLE) {
        require(ownerOf(tokenId) == a, "Invalid Owner");
        purchases[tokenId].pop();
        ownedTokens[_poolround][a].pop();
    }

    function setPoolAddress(address poolAddress) public onlyRole(DEFAULT_ADMIN_ROLE){
        _grantRole(MINTER_ROLE, poolAddress);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
