// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IERC165.sol";

contract ERC165 is IERC165 {
    // Mapping to store supported interface IDs
    mapping(bytes4 => bool) private _supportedInterfaces;

    /**
     * @dev Constructor registers the ERC165 interface itself.
     */
    constructor() {
        _registerInterface(bytes4(keccak256('supportsInterface(bytes4)')));
    }

    /**
     * @dev Checks if a given interface is supported.
     * @param interfaceID The interface ID to check for support.
     * @return bool Whether the interface is supported.
     */
    function supportsInterface(bytes4 interfaceID) external view override returns (bool) {
        return _supportedInterfaces[interfaceID];
    }

    /**
     * @dev Registers an interface to be supported by the contract.
     * @param interfaceID The interface ID to register.
     */
    function _registerInterface(bytes4 interfaceID) public {
        require(interfaceID != 0xffffffff, "ERC165: addInterface: this interface is invalid");
        _supportedInterfaces[interfaceID] = true;
    }
}
