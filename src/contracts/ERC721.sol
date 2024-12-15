// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC165.sol';
import './interfaces/IERC721.sol';

contract ERC721 is ERC165, IERC721 {

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _tokenOwner;

    // Mapping from owner address to number of owned tokens
    mapping(address => uint256) private _ownedTokenCount;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Constructor to register the ERC721 interface
    constructor() {
        _registerInterface(bytes4(keccak256('balanceOf(address)') ^
                                  keccak256('ownerOf(uint256)') ^
                                  keccak256('transferFrom(address,address,uint256)')));
    }

    /**
     * @dev Returns the number of tokens owned by the given address.
     * @param _owner The address to query the balance of.
     * @return uint256 The number of tokens owned by `_owner`.
     */
    function balanceOf(address _owner) public view override returns (uint256) {
        require(_owner != address(0), "ERC721: balanceOf: address zero is not valid");
        return _ownedTokenCount[_owner];
    }

    /**
     * @dev Returns the owner of the given token ID.
     * @param _tokenId The token ID to query the owner of.
     * @return address The address that owns the token.
     */
    function ownerOf(uint256 _tokenId) public view override returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), "ERC721: ownerOf: token does not exist");
        return owner;
    }

    /**
     * @dev Checks if a token exists by checking if it is owned by a non-zero address.
     * @param tokenId The token ID to check.
     * @return bool `true` if the token exists, otherwise `false`.
     */
    function _exists(uint256 tokenId) internal view returns (bool) {
        return _tokenOwner[tokenId] != address(0);
    }

    /**
     * @dev Mints a new token with a given ID and assigns it to an address.
     * @param to The address to mint the token to.
     * @param tokenId The token ID to mint.
     */
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to address zero is not valid");
        require(!_exists(tokenId), "ERC721: token already minted");
        _tokenOwner[tokenId] = to;
        _ownedTokenCount[to]++;
        emit Transfer(address(0), to, tokenId);
    }

    /**
     * @dev Transfers a token from one address to another.
     * @param from The current owner of the token.
     * @param to The new owner of the token.
     * @param tokenId The token ID to transfer.
     */
    function transferFrom(address from, address to, uint256 tokenId) public virtual override {
        require(from != address(0), "ERC721: transferFrom: invalid from address");
        require(to != address(0), "ERC721: transferFrom: invalid to address");
        require(_exists(tokenId), "ERC721: transferFrom: token does not exist");
        require(ownerOf(tokenId) == from, "ERC721: transferFrom: caller is not owner of the token");

        _tokenOwner[tokenId] = to;
        _ownedTokenCount[from]--;
        _ownedTokenCount[to]++;
        emit Transfer(from, to, tokenId);
    }

    // Add the approve function to allow an address to approve another address to transfer a token

    /**
     * @dev Approves another address to transfer a specific token on behalf of the owner.
     * @param to The address to be approved.
     * @param tokenId The token ID to approve.
     */
    function approve(address to, uint256 tokenId) public virtual {
        address owner = ownerOf(tokenId);
        require(to != owner, "ERC721: approve to owner is not allowed");
        require(msg.sender == owner, "ERC721: approve caller is not token owner");

        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    /**
     * @dev Returns the address approved to transfer a specific token.
     * @param tokenId The token ID to query the approval of.
     * @return address The approved address, or zero if no address is approved.
     */
    function getApproved(uint256 tokenId) public view virtual returns (address) {
        require(_exists(tokenId), "ERC721: getApproved: token does not exist");
        return _tokenApprovals[tokenId];
    }
}
