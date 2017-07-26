var QCoinBasic = artifacts.require("./QCoinBasic.sol");
var QCoin = artifacts.require("./QCoin.sol");

module.exports = function(deployer) {
    deployer.deploy(QCoinBasic, 100, 'QCoinBasic', 'QC', 2);
    deployer.deploy(QCoin, 100, 'QCoin', 'QC', 2, 0);
};