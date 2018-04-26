// Token(s)
var FrescoToken = artifacts.require("./contracts/Tokens/FrescoToken.sol");

module.exports = function(deployer, network, accounts) {
	deployer.deploy(FrescoToken);
};
