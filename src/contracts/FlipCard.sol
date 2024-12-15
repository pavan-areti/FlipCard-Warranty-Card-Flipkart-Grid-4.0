// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Connector.sol';

contract FlipCard is ERC721Connector {
    string[] public flipCards;

    struct CardDetails {
        string serialNumber;
        string email;
        string mobileNumber;
        string itemName;
        uint createdDate;
        uint expiryDate;
        string[] previousRepairs;
        uint lastRepairIndex;
        string flipcard;
    }

    mapping(string => CardDetails) public flipcardDetails;
    mapping(string => bool) public _flipcardExists;
    mapping(string => uint256) public _flipcardIds;
    mapping(string => CardDetails) public serialIdData;
    mapping(string => string[]) public repairs;

    // Getting the ID of a flipcard by its serial number
    function getFlipCardId(string memory flipCard) public view returns (uint256) {
        return _flipcardIds[flipCard];
    }

    /**
     * @dev Mint a new flipcard with specific details.
     * @param flipcard The unique ID of the flipcard.
     * @param serialNumber The serial number of the item.
     * @param email The email associated with the flipcard.
     * @param mobileNumber The mobile number associated with the flipcard.
     * @param itemName The item name associated with the flipcard.
     * @param expiryMonths The expiration period in months.
     */
    function mint(
        string memory flipcard,
        string memory serialNumber,
        string memory email,
        string memory mobileNumber,
        string memory itemName,
        uint expiryMonths
    ) public {
        require(!_flipcardExists[flipcard], "Error: flipcard already exists");

        flipCards.push(flipcard);
        uint _id = flipCards.length - 1;
        _mint(msg.sender, _id);
        _flipcardIds[flipcard] = _id;
        _flipcardExists[flipcard] = true;

        // Initialize flipcard details
        string[] memory temp; // Max of 100 repairs
        flipcardDetails[flipcard] = CardDetails(
            serialNumber,
            email,
            mobileNumber,
            itemName,
            block.timestamp,
            block.timestamp + expiryMonths * 30 * 24 * 60 * 60, // Expiry time in seconds
            temp,
            0,
            flipcard
        );

        // Link serial number to flipcard details
        serialIdData[serialNumber] = flipcardDetails[flipcard];
    }

    /**
     * @dev Transfer the ownership of a flipcard and update details.
     * @param to The address to transfer ownership to.
     * @param _id The ID of the flipcard to transfer.
     * @param email The new owner's email.
     * @param mobileNumber The new owner's mobile number.
     */
    function _transferFrom(address to, uint256 _id, string memory email, string memory mobileNumber) public {
        transferFrom(msg.sender, to, _id);
        
        // Update the flipcard details after the transfer
        string memory flipcard = flipCards[_id];
        flipcardDetails[flipcard].email = email;
        flipcardDetails[flipcard].mobileNumber = mobileNumber;
        serialIdData[flipcardDetails[flipcard].serialNumber] = flipcardDetails[flipcard];
    }

    /**
     * @dev Get the details of a flipcard.
     * @param flipcard The unique identifier of the flipcard.
     * @return The details of the specified flipcard.
     */
    function getData(string memory flipcard) public view returns (CardDetails memory) {
        return flipcardDetails[flipcard];
    }

    /**
     * @dev Get the owner of a flipcard by its serial number.
     * @param serialNumber The serial number of the flipcard.
     * @return The owner's email address.
     */
    function getOwnerBySerialNumber(string memory serialNumber) public view returns (string memory) {
        return serialIdData[serialNumber].email;
    }

    /**
     * @dev Add a repair record for a flipcard.
     * @param serialNumber The serial number of the flipcard.
     * @param repair The repair description.
     */
    function addRepair(string memory serialNumber, string memory repair) public {
        CardDetails storage card = flipcardDetails[serialIdData[serialNumber].flipcard];
        require(card.lastRepairIndex < 100, "Error: cannot add more than 100 repairs");
        
        // Add the repair and increment the repair index
        card.previousRepairs.push(repair);
        card.lastRepairIndex++;
    }


    // Constructor that sets the name and symbol of the FlipCard token
    constructor() ERC721Connector("FlipCard", "FC") {}
}
