require("dotenv").config();
const HDWalletProvider = require("@truffle/hdwallet-provider");
// const fs = require("fs");
// const mnemonic = fs.readFileSync(".secret").toString().trim();

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
    },
    moonbase: {
      provider: () =>
        new HDWalletProvider(
          process.env.OWNER_PRIV_KEY || "",
          process.env.MOONBASE || ""
        ),
      network_id: 1287,
      gas: 15000000,
      confirmation: 2,
      timeoutBlocks: 200,
      skipDryRun: true,
      websocket: true,
    },
    ropsten: {
      provider: () =>
        new HDWalletProvider(
          process.env.OWNER_PRIV_KEY || "",
          `https://ropsten.infura.io/v3/${process.env.INFURA_API_KEY}`
        ),
      network_id: 3,
      gas: 5500000,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true,
    },
    rinkeby: {
      provider: () =>
        new HDWalletProvider(
          process.env.OWNER_PRIV_KEY || "",
          `https://rinkeby.infura.io/v3/${process.env.INFURA_API_KEY}`
        ),
      network_id: 4,
      gas: 5500000,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true,
    },
    goerli: {
      provider: () =>
        new HDWalletProvider(
          process.env.OWNER_PRIV_KEY || "",
          `https://goerli.infura.io/v3/${process.env.INFURA_API_KEY}`
        ),
      network_id: 420,
      gas: 5500000,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true,
    }
  },

  mocha: {
    timeout: 100000,
  },
  compilers: {
    solc: {
      version: "0.8.14",
      docker: false,
      settings: {
        optimizer: {
          enabled: false,
          runs: 200,
        },
        evmVersion: "byzantium",
      },
    },
  },
  db: {
    enabled: false,
    host: "127.0.0.1",
    adapter: {
      name: "sqlite",
      settings: {
        directory: ".db",
      },
    },
  },
};
