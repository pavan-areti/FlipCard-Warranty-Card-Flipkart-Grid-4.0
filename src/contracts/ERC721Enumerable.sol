// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';

contract ERC721Enumerable is IERC721Enumerable,ERC721{
    uint256[] private _allTokens;
    
    // mapping from token id to position in array
    mapping(uint256 => uint256) private _allTokensIndex;

    // mapping of all tokens owned by the owner
    mapping(address => uint256[]) private _ownedTokens;   
    
    // mapping from token id to index of owners tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

   // constructor 
    constructor(){
        _registerInterface(bytes4(keccak256('totalSupply()')
                                  ^keccak256('tokenByIndex(uint256)')
                                  ^keccak256('tokenOfOwnerByIndex(address,uint256)')));
    }

    // total supply
    function totalSupply() public view override returns (uint256) {
        return _allTokens.length;
    }
    
    // gives a list of tokens owned by that owner
    function allTokensOfOwner(address _owner) public view returns (uint256[] memory) {
        return _ownedTokens[_owner];
    }

    // minting
    function _mint(address to, uint256 tokenId)internal override(ERC721){
        super._mint(to, tokenId);
        _addTokensToAllTokensEnumeration(tokenId);
        _addTokensToOwnerEnumeration(to,tokenId);
    }

    // transfer 
    function transferFrom(address from, address to, uint256 tokenId)public override(ERC721) {
        super.transferFrom(from, to, tokenId);
        _removeTokensFromOwnerEnumeration(from,tokenId);
        _addTokensToOwnerEnumeration(to,tokenId);
    }

    //token by index
    function tokenByIndex(uint256 index) public view override returns (uint256) {
        require(index < totalSupply(), "ERC721: tokenByIndex: index out of range");
        return _allTokens[index];
    }

    //token by owner index
    function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
        require(owner != address(0), "ERC721: tokenOfOwnerByIndex: caller is not allowed to be null");
        require(index < _ownedTokens[owner].length, "ERC721: tokenOfOwnerByIndex: caller is not allowed to be null");
        uint256 tokenId = _ownedTokens[owner][index];
        return tokenId;
    }

    // adding tokens to all tokens
    function _addTokensToAllTokensEnumeration(uint256 tokenId) public {
        _allTokens.push(tokenId);
        _allTokensIndex[tokenId] = _allTokens.length - 1;
    }

    // adding tokens to owners tokens
    function _addTokensToOwnerEnumeration(address to,uint256 tokenId) public {
        _ownedTokens[to].push(tokenId);
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length - 1;
    }

    // removing tokens from owners tokens
    function _removeTokensFromOwnerEnumeration(address from,uint256 tokenId) public {
        uint256 index = _ownedTokensIndex[tokenId];
        for(uint i = index; i < _ownedTokens[from].length - 1; i++){
            _ownedTokens[from][i] = _ownedTokens[from][i+1];
            _ownedTokensIndex[_ownedTokens[from][i]] = i;
        }
        _ownedTokens[from].pop();
    }

}