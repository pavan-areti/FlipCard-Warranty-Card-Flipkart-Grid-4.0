// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721Enumerable {

    /**
     * @dev Returns the total number of tokens in existence.
     * @return The total supply of tokens.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the token ID at a given index of all tokens in the contract.
     * @param _index The index of the token to query.
     * @return The token ID at the given index.
     */
    function tokenByIndex(uint256 _index) external view returns (uint256);

    /**
     * @dev Returns the token ID at a given index of the tokens owned by a specific address.
     * @param _owner The address owning the tokens.
     * @param _index The index of the token to query.
     * @return The token ID owned by the given address at the given index.
     */
    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
}
