const HDWalletProvider = require("truffle-hdwallet-provider");
const Web3 = require("web3");
const { interface, bytecode } = require("./compile");

const provider = new HDWalletProvider(
  "input ethics wagon abstract ripple ring imitate horse permit spell match flight",
  "https://rinkeby.infura.io/v3/b1ae4a20e2f0455987332b0fc23a42b3"
);

const web3 = new Web3(provider);

const deploy = async () => {
  try {
    const accounts = await web3.eth.getAccounts();

    console.log("Attempting to deploy from account", accounts[0]);
    const result = await new web3.eth.Contract(JSON.parse(interface))
      .deploy({ data: bytecode })
      .send({
        from: accounts[0],
        gasPrice: await web3.eth.getGasPrice(),
        gasLimit: web3.utils.toHex(1000000),
      });

    console.log(interface);
    console.log("Contract deployed to", result.options.address);
  } catch (ex) {
    console.log(ex);
  }
};
deploy();
