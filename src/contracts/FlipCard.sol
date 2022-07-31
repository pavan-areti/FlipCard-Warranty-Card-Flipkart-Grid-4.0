// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import './ERC721Connector.sol';

contract FlipCard is ERC721Connector{
     string[] public flipCards;

     struct CardDetails{
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

     mapping(string => CardDetails)public serialIdData;

     mapping(string => string[])public repairs;

     // getting id of flipcard
     function getFlipCardId(string memory flipCard) public view returns (uint256){
         return _flipcardIds[flipCard];
     }
     
     // minting
     function mint(string memory flipcard,string memory serialNumber,string memory email,string memory mobileNumber,string memory itemName,uint expiryMonths) public {
          require(!_flipcardExists[flipcard],"Error: minting a flipcard that already exists");
          flipCards.push(flipcard);
          uint _id = flipCards.length - 1;
          
          _mint(msg.sender, _id);
          _flipcardIds[flipcard] = _id; 
          _flipcardExists[flipcard] = true;
          string[] memory temp = new string[](100);
          flipcardDetails[flipcard] = CardDetails(
                                         serialNumber,
                                         email,
                                         mobileNumber,
                                         itemName,
                                         block.timestamp,
                                         block.timestamp+expiryMonths*30*24*60*60,
                                         temp,
                                         0,
                                         flipcard
                                         );
                                 
            serialIdData[serialNumber] = flipcardDetails[flipcard];  
     }

     // transfer token
     function _transferFrom(address to,uint256 _id,string memory email,string memory mobileNumber) public {
          transferFrom(msg.sender, to, _id);
          flipcardDetails[flipCards[_id]].email = email;
          flipcardDetails[flipCards[_id]].mobileNumber = mobileNumber;
          serialIdData[flipcardDetails[flipCards[_id]].serialNumber] = flipcardDetails[flipCards[_id]];
     }

     // send Data
     function getData(string memory flipcard) public view returns (CardDetails memory){
         return flipcardDetails[flipcard];
     }

     //get owner by flipcard serial number
     function getOwnerBySerialNumber(string memory serialNumber) public view returns (string memory){
         return serialIdData[serialNumber].email;
     }

     // add repair 
    function addRepair(string memory serialNumber,string memory repair) public {
        require(serialIdData[serialNumber].lastRepairIndex < 100,"Error: cannot add more than 100 repairs");
        flipcardDetails[serialIdData[serialNumber].flipcard].previousRepairs[serialIdData[serialNumber].lastRepairIndex] = repair;
        serialIdData[serialNumber].lastRepairIndex++;
    }


    
     constructor() ERC721Connector("FlipCard","FC"){}
}