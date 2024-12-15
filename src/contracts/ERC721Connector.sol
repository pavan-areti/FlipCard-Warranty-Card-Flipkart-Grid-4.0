// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Metadata.sol';
import './ERC721Enumerable.sol';

contract ERC721Connector is ERC721Metadata, ERC721Enumerable {

    /**
     * @dev Constructor that initializes the ERC721Metadata contract
     * and the ERC721Enumerable contract with the provided `name` and `symbol`.
     * @param name The name of the token collection.
     * @param symbol The symbol of the token collection.
     */
    constructor(string memory name, string memory symbol) ERC721Metadata(name, symbol) {
        // No additional logic needed for now
    }
}
