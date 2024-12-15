// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './interfaces/IERC721Metadata.sol';
import './ERC165.sol';

contract ERC721Metadata is IERC721Metadata, ERC165 {
    string private _name;
    string private _symbol;

    /**
     * @dev Constructor that sets the name and symbol of the token.
     * It also registers the ERC721Metadata interface.
     * @param named The name of the token collection.
     * @param symboled The symbol of the token collection.
     */
    constructor(string memory named, string memory symboled) {
        _registerInterface(bytes4(keccak256('name()') ^
                                  keccak256('symbol()')));
        _name = named;
        _symbol = symboled;
    }

    /**
     * @dev Returns the name of the token collection.
     * @return string The name of the token.
     */
    function name() external view override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token collection.
     * @return string The symbol of the token.
     */
    function symbol() external view override returns (string memory) {
        return _symbol;
    }
}
