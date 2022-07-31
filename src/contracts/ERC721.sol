// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import './ERC165.sol';
import './interfaces/IERC721.sol';

contract ERC721 is ERC165, IERC721 {

     // mapping from token id to owner
     mapping(uint256 => address) private _tokenOwner;

     // mapping of all tokens owned by the caller
     mapping(address => uint256) private _ownedTokenCount;

    // mapping from token id to addresses
    mapping(uint256 => address) private _tokenApprovals;

    // constructor 
    constructor(){
        _registerInterface(bytes4(keccak256('balanceOf(address)')
                                  ^keccak256('ownerOf(uint256)')
                                  ^keccak256('transferFrom(address,address,uint256)')));
    }
    
    // balance of person
    function balanceOf(address _owner) public view returns (uint256) {
        require(_owner != address(0), "ERC721: balanceOf: caller is not allowed to be null");
        return _ownedTokenCount[_owner];
    }
    
    // get owner of token
    function ownerOf(uint256 _tokenId) public view returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), "ERC721: ownerOf: caller is not allowed to be null");
        return owner;
    }

    // check if token is already existing
    function _exists(uint256 tokenId) public view returns (bool){
        return _tokenOwner[tokenId] != address(0);
    }

     // minting
     function _mint(address to, uint256 tokenId) internal virtual{
         require(to != address(0),"ERC721: mint to address is invalid");
         require(!_exists(tokenId),"ERC721: minting a token that already exists");
         _tokenOwner[tokenId] = to;
         _ownedTokenCount[to]++;
         emit Transfer(address(0), to, tokenId);
     }

    // transfer token
    function transferFrom(address from, address to, uint256 tokenId) public virtual{
        require(from != address(0), "ERC721: transferFrom: caller is not allowed to be null");
        require(to != address(0), "ERC721: transferFrom: to address is invalid");
        require(_exists(tokenId), "ERC721: transferFrom: tokenId does not exist");
        require(ownerOf(tokenId) == from, "ERC721: transferFrom: caller is not allowed to transfer this token");
        _tokenOwner[tokenId] = to;
        _ownedTokenCount[from]--;
        _ownedTokenCount[to]++;
        emit Transfer(from, to, tokenId);
    }
     
    // approve token for transfer

}