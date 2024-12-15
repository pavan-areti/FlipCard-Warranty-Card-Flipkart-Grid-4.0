import React, { useState, useEffect } from "react";
import "bootstrap/dist/css/bootstrap.css";
import { Card } from "./Card.js";
import Web3 from "web3";
import FlipCard from "../abis/FlipCard.json";
import detectEthereumProvider from "@metamask/detect-provider";

const App = () => {
  const [account, setAccount] = useState([]);
  const [contract, setContract] = useState(null);
  const [totalsupply, setTotalsupply] = useState(0);
  const [flipcards, setFlipcards] = useState([]);
  const [tokenslist, setTokenslist] = useState([]);

  const loadWeb3 = async () => {
    const provider = await detectEthereumProvider();

    if (provider) {
      window.web3 = new Web3(provider);
      loadBlockchainData();
    } else {
      window.alert("Please install MetaMask");
    }
  };

  // sends mail on minting
  const sendMail = (recipient, card) => {
    let url = card;
    url = url.replace(/ /g, "%20");
    console.log(url);
    window.Email.send({
      Host: "smtp.elasticemail.com",
      Username: "teambrainstormflipkart@gmail.com",
      Password: "1C39ED47C4F3613584C3C1F324F4BDFE5699",
      To: recipient,
      From: "teambrainstormflipkart@gmail.com",
      Subject: "NFT Recieved",
      Body: `Succesfully minted NFT \r\n please check your wallet and url for the NFT is \r\n ${url}`,
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

  // fetching required data to display
  const loadBlockchainData = async () => {
    const web3 = window.web3;
    const accounts = await web3.eth.requestAccounts();
    setAccount(accounts);

    const networkId = await web3.eth.net.getId();
    const networkData = FlipCard.networks[networkId];
    if (networkData) {
      var address = networkData.address;
      var abi = FlipCard.abi;
      var contract = new web3.eth.Contract(abi, address);
      setContract(contract);

      const totalSupply = await contract.methods.totalSupply().call();
      setTotalsupply(totalSupply);

      contract.methods
        .allTokensOfOwner(accounts[0])
        .call()
        .then((tokens) => {
          for (let i = 0; i < tokens.length; i++) {
            contract.methods
              .flipCards(tokens[i])
              .call()
              .then((card) => {
                setFlipcards((flipcards) => [...flipcards, card]);
                setTokenslist((tokenslist) => [...tokenslist, tokens[i]]);
              })
              .catch((err) => {
                console.log(err);
              });
          }
        });
    } else {
      window.alert("Smart contract not deployed to detected network");
    }
  };

  // minting the flipcard
  const mint = async (
    serialNumber,
    email,
    mobileNumber,
    productName,
    expiryMonths
  ) => {
    const card = `https://res.cloudinary.com/dvjzw8vlh/image/upload/co_rgb:ffffff,e_blue:0,l_text:montserrat_60_style_light:Serial Number - ${serialNumber},x_12,y_247/co_rgb:ffffff,l_text:montserrat_60_style_light:Item : ${productName},y_323/v1658395427/Warranty_Card_lmg8v2.png`;
    contract.methods
      .mint(card, serialNumber, email, mobileNumber, productName, expiryMonths)
      .send({ from: account[0] })
      .on("transactionHash", (hash) => {
        console.log("On transactionHash - ");
        console.log(hash);
      })
      .on("confirmation", (confirmationNumber, receipt) => {
        console.log("on confirmation - Confirmation Number");
        console.log(confirmationNumber);
        console.log("receipt");
        console.log(receipt);
        setFlipcards((flipcards) => [...flipcards, card]);
        console.log(card);
        console.log(flipcards);
        sendMail(email, card);
        // window.location.reload();
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

  // finding the owner of the NFT
  const findOwner = async (serialNumber) => {
    const owner = await contract.methods
      .getOwnerBySerialNumber(serialNumber)
      .call();
    alert(`The owner of NFT with serial number ${serialNumber} is ${owner}`);
  };

  // Adding repair by the Admin  
  const addRepair = async (serialNumber, repair) => {
    contract.methods
      .addRepair(serialNumber, repair)
      .send({ from: account[0] })
      .on("transactionHash", (hash) => {
        console.log("On transactionHash - ");
        console.log(hash);
      })
      .on("confirmation", (confirmationNumber, receipt) => {
        console.log("on confirmation - Confirmation Number");
        console.log(confirmationNumber);
        console.log("receipt");
        console.log(receipt);
        console.log("repair added succesfullly");
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

  useEffect(() => {
    loadWeb3();
  }, []);

  useEffect(() => {}, [flipcards]);

  useEffect(() => {}, [account]);

  return (
    <div>
      <nav>
        <div className="navbar navbar-dark  bg-dark flex-md-nowrap p-0 shadow">
          <div
            className="navbar-brand col-sm-3 col-md-3 mr-0"
            style={{ color: "white" }}
          >
            Flipcard Warranty Zone
          </div>
          <div className="navbar-nav">
            <ul className="navbar-nav px-3">
              <li className="nav-item text-nowrap text-white">
                {account.length > 0 ? (
                  <div>{account[0]}</div>
                ) : (
                  <div>Please login</div>
                )}
              </li>
            </ul>
          </div>
        </div>
      </nav>

      <div className="container-fluid mt-1">
        {/* // as there is no authentication system , we hardcoded like this using one of our address */}
        {account[0] == 0x65281f175efe54bf8fa756b3dca2f66efc5ab63c ? (
          <>
            <div className="row">
              <main role="main" className="col-lg-12 d-flex text-center">
                <div
                  className="content mr-auto ml-auto"
                  style={{ opacity: "0.8" }}
                >
                  <h1> FlipCard - Warranty Place </h1>

                  <form
                    onSubmit={(event) => {
                      event.preventDefault();
                      const serialNumber = event.target.serialNumber.value;
                      const email = event.target.email.value;
                      const mobileNumber = event.target.mobileNumber.value;
                      const productName = event.target.productName.value;
                      const expiryMonths = event.target.expiryMonths.value;
                      mint(
                        serialNumber,
                        email,
                        mobileNumber,
                        productName,
                        expiryMonths
                      );
                    }}
                  >
                    <input
                      type="text"
                      placeholder="Enter Serial Number"
                      name="serialNumber"
                      className="form-control mb-1"
                      required
                    />
                    <input
                      type="email"
                      placeholder="Enter your email"
                      name="email"
                      className="form-control mb-1"
                      required
                    />
                    <input
                      type="text"
                      placeholder="Enter your mobile number"
                      name="mobileNumber"
                      className="form-control mb-1"
                    />
                    <input
                      type="text"
                      placeholder="Enter Product Name"
                      name="productName"
                      className="form-control mb-1"
                      required
                    />

                    <input
                      type="number"
                      placeholder="Expires after ( in months )"
                      name="expiryMonths"
                      className="form-control mb-1"
                      required
                    />

                    <button className="btn btn-primary" type="submit">
                      Mint
                    </button>
                  </form>
                </div>
              </main>
            </div>

            <hr />

            <div className="row">
              <main role="main" className="col-lg-12 d-flex text-center">
                <div
                  className="content mr-auto ml-auto"
                  style={{ opacity: "0.8" }}
                >
                  <h3> Find Owner </h3>
                  <form
                    onSubmit={(event) => {
                      event.preventDefault();
                      const serialNumber = event.target.serialNumber.value;
                      findOwner(serialNumber);
                    }}
                  >
                    <div className="row">
                      <div className="col-lg-10">
                        <input
                          type="text"
                          placeholder="Enter Serial Number"
                          name="serialNumber"
                          className="form-control mb-1"
                          required
                        />
                      </div>
                      <div className="col-lg-2">
                        {" "}
                        <button className="btn btn-primary" type="submit">
                          find
                        </button>
                      </div>
                    </div>
                  </form>
                </div>
              </main>
            </div>

            <hr />

            <div className="row">
              <main role="main" className="col-lg-12 d-flex text-center">
                <div
                  className="content mr-auto ml-auto"
                  style={{ opacity: "0.8" }}
                >
                  <h3> Repair </h3>
                  <form
                    onSubmit={(event) => {
                      event.preventDefault();
                      const serialNumber = event.target.serialNumber.value;
                      let Repair = event.target.Repair.value;
                      //date time string
                      let date = new Date();
                      let dateString = date.toISOString();
                      Repair += " " + dateString;
                      console.log(Repair);
                      addRepair(serialNumber, Repair);
                    }}
                  >
                    <input
                      type="text"
                      placeholder="Enter Serial Number"
                      name="serialNumber"
                      className="form-control mb-1"
                      required
                    />
                    <input
                      type="text"
                      placeholder="Enter repair description"
                      name="Repair"
                      className="form-control mb-1"
                      required
                    />
                    <button className="btn btn-primary" type="submit">
                      repair
                    </button>
                  </form>
                </div>
              </main>
            </div>

            <hr />
            </>
                    ) : (
                      <div></div>
                    )}
            <div className="row textCenter">
              {flipcards.map((card, key) => {
                return (
                  <Card
                    card={card}
                    contract={contract}
                    cardid={key}
                    account={account[0]}
                    tokens={tokenslist}
                  />
                );
              })}
            </div>


      </div>
    </div>
  );
};

export default App;
