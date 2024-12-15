import React, { useState, useEffect } from "react";
import {
  MDBCard,
  MDBCardBody,
  MDBCardText,
  MDBCardTitle,
  MDBCardImage,
} from "mdb-react-ui-kit";
import Popup from "./Popup.js";
import "./Popup.css";

// warranty card component
export const Card = ({ card, contract, account }) => {
  const [token_id, setToken_id] = useState("");
  const [email, setEmail] = useState("");
  const [phoneNumber, setPhoneNumber] = useState("");
  const [expiryDate, setExpiryDate] = useState("");
  const [createdDate, setCreatedDate] = useState("");
  const [isExpired, setIsExpired] = useState(false);
  const [isOpen, setIsOpen] = useState(false);
  const [repairs, setRepairs] = useState([]);

  // sending mail on NFT Transfer
  const sendMail = (recipient) => {
    let url = card;
    url = url.replace(/ /g, "%20");
    window.Email.send({
      Host: "smtp.elasticemail.com",
      Username: "teambrainstormflipkart@gmail.com",
      //password hidden for security reasons
      Password: "********************************",
      To: recipient,
      From: "teambrainstormflipkart@gmail.com",
      Subject: "NFT Recieved",
      Body: `you recived a NFT from ${account} \r\n please check your wallet and url for the NFT is \r\n ${url}`,
      Attachments: [
        {
          name: "NFT.png",
          path: card,
        },
      ],
    })
      .then((e) => {
        console.log(e);
      })
      .catch((e) => {
        console.log("error", e);
      });
  };

  // getting the token id
  const getToken_id = async () => {
    const temp = await contract.methods.getFlipCardId(card).call();
    setToken_id(temp);
  };

  // getting the data of NFT to display on warranty cards
  const getData = async () => {
    const temp = await contract.methods.getData(card).call();
    console.log(temp)
    // Ensure that temp.expiryDate is a BigInt and convert to a Number (in milliseconds)
    const tempdate = Number(temp.expiryDate); // Convert BigInt to Number if needed
    const expdate = new Date(tempdate * 1000); // Convert seconds to milliseconds
    const presentdate = new Date();
    
    // Check expiry
    if (expdate < presentdate) {
      setIsExpired(true);
    }
  
    // Setting expiry date
    setExpiryDate(expdate.toLocaleDateString());
    
    // Convert createdDate (assuming it's a BigInt) to Date
    const tempdate2 = Number(temp.createdDate); // Convert BigInt to Number if needed
    const createddate = new Date(tempdate2 * 1000);
    setCreatedDate(createddate.toLocaleDateString());
  
    // Set email and phone number
    setEmail(temp.email);
    setPhoneNumber(temp.mobileNumber);
  
    const repairs = [];
    // Handle previous repairs (ensure temp.previousRepairs is not BigInt and is an array)
    for (let i = 0; i < temp.previousRepairs.length; i++) {
      if (temp.previousRepairs[i] === "") {
        break;
      }
      repairs.push(temp.previousRepairs[i]); // Push repair info into repairs array
    }
    setRepairs(repairs)
  };
  

  useEffect(() => {
    getToken_id();
    getData();
  }, []);

  // Transferring the NFT
  const transfer = async (recipient, email, mobileNumber) => {
    contract.methods
      ._transferFrom(recipient, token_id, email, mobileNumber)
      .send({ from: account })
      .on("transactionHash", (hash) => {
        console.log("On transactionHash - ");
        console.log(hash);
      })
      .on("confirmation", (confirmationNumber, receipt) => {
        console.log("on confirmation - Confirmation Number");
        console.log(confirmationNumber);
        console.log("receipt");
        console.log(receipt);
        sendMail(email);
        window.location.reload();
      })
      .on("receipt", (receipt) => {
        console.log("on receipt");
      })
      .on("error", (error, receipt) => {
        console.log("on error");
        console.log("Transaction was rejected by the network with error");
        console.log(error);
        if (receipt) {
          console.log("A receipt was included with rejection as follows:");
          console.log(receipt);
        }
      });
  };

  return (
    <div className="col-sm-4">
      <MDBCard className="mt-3 mb-3">
        <MDBCardImage cascade src={card} top hover overlay="white-slight" />
        <MDBCardBody>
          <MDBCardTitle>FlipCard</MDBCardTitle>
          <MDBCardText>Owned by : {email}</MDBCardText>
          <MDBCardText>Mobile Number : {phoneNumber}</MDBCardText>
          <MDBCardText>Created Date : {createdDate}</MDBCardText>
          <MDBCardText>
            Expiry Date : {!isExpired ? expiryDate : "Already Expired"}
          </MDBCardText>
          <form
            onSubmit={(e) => {
              e.preventDefault();
              const recipient = e.target.recipient.value;
              const email = e.target.email.value;
              const mobileNumber = e.target.mobileNumber.value;
              transfer(recipient, email, mobileNumber);
            }}
          >
            <input
              type="text"
              placeholder="Enter Recepient Address"
              name="recipient"
              className="form-control mb-1"
              required
            />
            <input
              type="text"
              placeholder="Enter Recepient email id"
              name="email"
              className="form-control mb-1"
              required
            />
            <input
              type="text"
              placeholder="Enter Recepient mobile number"
              name="mobileNumber"
              className="form-control mb-1"
              required
            />
            <button className="btn btn-primary mt-3" type="submit">
              Transfer
            </button>
            <button
              className="btn btn-primary ml-3 mt-3"
              onClick={(e) => {
                e.preventDefault();
                setIsOpen(true);
                console.log(isOpen);
              }}
            >
              repairs
            </button>
          </form>
        </MDBCardBody>
      </MDBCard>
      <Popup isOpen={isOpen} setIsOpen={setIsOpen} repairs={repairs}></Popup>
    </div>
  );
};
