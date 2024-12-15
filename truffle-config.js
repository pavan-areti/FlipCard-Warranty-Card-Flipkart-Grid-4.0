// truffle-config.js

// CommonJS version
require('dotenv').config();

const networks = {
  development: {
    host: "127.0.0.1", // Localhost
    port: 7545, // Ganache default port
    network_id: "*", // Matches any network id
  }
};

const contracts_directory = "./src/contracts/";
const contracts_build_directory = "./src/abis/";

const compilers = {
  solc: {
    version: "^0.8.0", // Specify the Solidity compiler version
    settings: {
      optimizer: {
        enabled: true, // Enable optimization
        runs: 200 // Optimize for how many times you intend to run the code
      },
      evmVersion: "istanbul" // EVM version compatibility
    }
  }
};

module.exports = { networks, contracts_directory, contracts_build_directory, compilers };
