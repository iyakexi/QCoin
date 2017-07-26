var QCoin = artifacts.require("./QCoin.sol");

contract('QCoin', function(accounts) {

    // Test Case#1
    // Expected behavior - result is initialized to 100
    it("check initialized balance", function() {
        var qcoin;

        return QCoin.deployed().then(function(instance) {
            qcoin = instance;
            return qcoin.getBalance.call(accounts[0]);
        }).then(function(result) {
            //console.log(result);
            assert.equal(result.valueOf(), 100, "QCoin initialized with value NOT equal to 100!!!");
        });
    });

    // Test Case#2
    // Check Transfer
    it("check transfer", function() {
        var qcoin;

        return QCoin.deployed().then(function(instance) {
            qcoin = instance;
            return qcoin.transfer(accounts[1], 20);
        }).then(function() {
            return qcoin.getBalance.call(accounts[0]);
        }).then(function(result) {
            assert.equal(result, 80, accounts[0] + ": Balance after outcom 20 should be 80");
        }).then(function(result) {
            //console.log(result);
            return qcoin.getBalance.call(accounts[1]);
        }).then(function(result) {
            //console.log(result);
            assert.equal(result, 20, accounts[1] + ": Balance after incom 20 should be 20");
        });
    });

});