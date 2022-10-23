const CoinToss = artifacts.require("CoinToss");

module.exports = function (deployer, accounts) {
  deployer.deploy(CoinToss);
};
