const path = require("path");
const fs = require("fs");
const solc = require("solc");

const fundMePath = path.resolve(__dirname, "contracts", "FundMe.sol");
const source = fs.readFileSync(fundMePath, "utf8");
module.exports = solc.compile(source, 1).contracts[":FundMe"];
