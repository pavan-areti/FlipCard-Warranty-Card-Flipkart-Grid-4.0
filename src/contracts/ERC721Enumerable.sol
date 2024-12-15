// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';

contract ERC721Enumerable is IERC721Enumerable, ERC721 {
    uint256[] private _allTokens;

    // Mapping from token ID to position in the allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;

    // Mapping of all tokens owned by an address
    mapping(address => uint256[]) private _ownedTokens;

    // Mapping from token ID to index in the owner's tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    // Constructor registers the ERC721Enumerable interface
    constructor() {
        _registerInterface(bytes4(keccak256('totalSupply()') ^
                                  keccak256('tokenByIndex(uint256)') ^
                                  keccak256('tokenOfOwnerByIndex(address,uint256)')));
    }

    /**
     * @dev Returns the total supply of tokens.
     * @return uint256 The total supply of tokens.
     */
    function totalSupply() public view override returns (uint256) {
        return _allTokens.length;
    }

    /**
     * @dev Returns the list of all tokens owned by the specified address.
     * @param _owner The address to query.
     * @return uint256[] An array of token IDs owned by `_owner`.
     */
    function allTokensOfOwner(address _owner) public view returns (uint256[] memory) {
        return _ownedTokens[_owner];
    }

    /**
     * @dev Mints a new token and adds it to the global and owner-specific enumerations.
     * @param to The address to mint the token to.
     * @param tokenId The ID of the token to mint.
     */
    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);
        _addTokensToAllTokensEnumeration(tokenId);
        _addTokensToOwnerEnumeration(to, tokenId);
    }

    /**
     * @dev Transfers a token and updates the enumerations for both the sender and receiver.
     * @param from The address to transfer the token from.
     * @param to The address to transfer the token to.
     * @param tokenId The ID of the token to transfer.
     */
    function transferFrom(address from, address to, uint256 tokenId) public override(ERC721) {
        super.transferFrom(from, to, tokenId);
        _removeTokensFromOwnerEnumeration(from, tokenId);
        _addTokensToOwnerEnumeration(to, tokenId);
    }

    /**
     * @dev Returns the token ID at a specific index in the global token list.
     * @param index The index to query.
     * @return uint256 The token ID at the specified index.
     */
    function tokenByIndex(uint256 index) public view override returns (uint256) {
        require(index < totalSupply(), "ERC721: tokenByIndex: index out of range");
        return _allTokens[index];
    }

    /**
     * @dev Returns the token ID at a specific index in the owner's token list.
     * @param owner The owner of the tokens.
     * @param index The index to query.
     * @return uint256 The token ID at the specified index.
     */
    function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
        require(owner != address(0), "ERC721: tokenOfOwnerByIndex: invalid address");
        require(index < _ownedTokens[owner].length, "ERC721: tokenOfOwnerByIndex: index out of range");
        return _ownedTokens[owner][index];
    }

    /**
     * @dev Adds a token to the global list of tokens and updates the index.
     * @param tokenId The ID of the token to add.
     */
    function _addTokensToAllTokensEnumeration(uint256 tokenId) internal {
        _allTokens.push(tokenId);
        _allTokensIndex[tokenId] = _allTokens.length - 1;
    }

    /**
     * @dev Adds a token to the owner's list of tokens and updates the index.
     * @param to The address of the token's owner.
     * @param tokenId The ID of the token to add.
     */
    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) internal {
        _ownedTokens[to].push(tokenId);
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length - 1;
    }

    /**
     * @dev Removes a token from the owner's list and updates the index.
     * @param from The address of the previous owner.
     * @param tokenId The ID of the token to remove.
     */
    function _removeTokensFromOwnerEnumeration(address from, uint256 tokenId) internal {
        uint256 index = _ownedTokensIndex[tokenId];
        uint256 lastIndex = _ownedTokens[from].length - 1;

        if (index != lastIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastIndex];
            _ownedTokens[from][index] = lastTokenId;
            _ownedTokensIndex[lastTokenId] = index;
        }

        _ownedTokens[from].pop();
        delete _ownedTokensIndex[tokenId];
    }
}
