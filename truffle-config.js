
module.exports = {
  networks: {

    development: {
     host: "127.0.0.1",     // Localhost (default: none)
     port: 7545,            // Standard Ethereum port (default: none)
     network_id: "*",       // Any network (default: none)
    },
    // ropsten: {
    //   provider: () => new HDWalletProvider(
    //     mnemonic,
    //     process.env.ROPSTEN_URL),
    //   network_id: 3
    // },
  },

  contracts_directory: './src/contracts/',
  contracts_build_directory: './src/abis/',

  // Configure your compilers
  compilers: {
    solc: {
      version: "^0.8.0",
      optimiser: {
        enabled: true,
        runs: 200
      }
    }
  }
}
