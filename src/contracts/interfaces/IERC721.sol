// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title IERC721 Interface
/// @notice Interface for the ERC721 Non-Fungible Token Standard
/// @dev Extends the ERC165 interface
interface IERC721 /* is ERC165 */ {
    /// @notice This emits when ownership of any NFT changes by any mechanism.
    /// @dev This event emits when NFTs are transferred, including zero value transfers.
    /// @param _from The address of the previous owner of the token
    /// @param _to The address of the new owner of the token
    /// @param _tokenId The identifier of the token transferred
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    /// @notice This emits when the approved address for an NFT is changed or reaffirmed.
    /// @dev The zero address indicates there is no approved address.
    /// @param _owner The owner of the token
    /// @param _approved The address that is approved
    /// @param _tokenId The identifier of the token approved
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

    /// @notice Count all NFTs assigned to an owner
    /// @param _owner The address to query the balance of
    /// @return uint256 The number of NFTs owned by `_owner`
    function balanceOf(address _owner) external view returns (uint256);

    /// @notice Find the owner of an NFT
    /// @param _tokenId The identifier for an NFT
    /// @return address The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) external view returns (address);

    /// @notice Transfer ownership of an NFT from one address to another address
    /// @dev Throws if `_to` is the zero address. Throws if `_from` is not the current owner.
    ///      Throws if `_tokenId` is not a valid NFT. Must emit `Transfer` event.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function transferFrom(address _from, address _to, uint256 _tokenId) external;
}
