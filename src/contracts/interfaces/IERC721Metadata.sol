// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721Metadata {

    /**
     * @dev Returns the name of the token.
     * @return The name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     * @return The symbol of the token.
     */
    function symbol() external view returns (string memory);
}
