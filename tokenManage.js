var fs = require('fs');
const Web3 = require("web3");
const web3 = new Web3(new Web3.providers.HttpProvider(process.env.MAIN_PROVIDER));


module.exports.sendGamiflyToken = async (public_address, amount) => {
  try {
    var contract_address = process.env.TOKEN_CONTRACT_ADDRESS;
    var contract_jsonFile = "./usdc.json";
    var contract_parsed = JSON.parse(fs.readFileSync(contract_jsonFile));
    var contract_abi = contract_parsed.abi;
    var contract_router = new web3.eth.Contract(contract_abi, web3.utils.toChecksumAddress(contract_address));
    const tx = await contract_router.methods.transfer(public_address, web3.utils.toWei(amount.toString(), 'ether'));

    const gasPrice = await web3.eth.getGasPrice();
    const _data = tx.encodeABI();
    const nonce = await web3.eth.getTransactionCount(process.env.OWNER_PUBLIC_ADDRESS);

    const signedTx = await web3.eth.accounts.signTransaction(
      {
        to: web3.utils.toChecksumAddress(process.env.TOKEN_CONTRACT_ADDRESS),
        data: _data,
        gasLimit: 3100000,
        gasPrice: parseInt(gasPrice * 1.4),
        nonce: nonce
      },
      process.env.OWNER_PRIVATE_KEY
    );
    const token_hash = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);
    const hash = await token_hash.transactionHash;
    console.log("Success Hash ", hash)
    return { result: true, message: "success", hash: hash };
  } catch (error) {
    console.log("Send Token Error ", error)
    if (error.message.includes("reverted")) {
      console.log("Send Token error 1", error);
      const errorMessage = JSON.parse(error.message.substring(error.message.indexOf("{"))).revertReason;
      return { result: false, message: errorMessage };
    } else {
      return { result: false, message: error.message }
    }
  }
};
