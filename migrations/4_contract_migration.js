// Node.js Libraries
var BigNumber = web3.BigNumber;

// Tokens
var FrescoToken = artifacts.require("./contracts/Tokens/FrescoToken.sol");

// Contract(s)
var FrescoCrowdsale = artifacts.require("./contracts/FrescoCrowdsale.sol");
// FrescoCrowdsale.save("");
var SafeMathLib = artifacts.require("./contracts/SafeMathLib.sol");
var MilestonePricing = artifacts.require("./contracts/MilestonePricing.sol");

var startTimestamp = 1521104400; // Thursday, 15 March 2018 09:00:00
var endTimestamp = 1523826000; // Sunday, 15 April 2018 21:00:00
var TotalTokenForSale = new BigNumber(300000000 * 10 ** 18); // 300M
var minWeiToRaise = web3.toWei(4500, 'ether'); // approx 30M tokens in presale

module.exports = function(deployer, network, accounts) {
	// (address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _crowdsaleTokenCap) CrowdsaleBase(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
    deployer.link(SafeMathLib, FrescoCrowdsale);
	deployer.deploy(FrescoCrowdsale, FrescoToken.address, MilestonePricing.address, accounts[0],
					startTimestamp, endTimestamp, minWeiToRaise, TotalTokenForSale).then(function(){
						return FrescoCrowdsale.at(FrescoCrowdsale.address).setAPIAdmin(accounts[0]);
						
					}).then(function(){
						return FrescoToken.at(FrescoToken.address).approve(FrescoCrowdsale.address, TotalTokenForSale, {from : web3.eth.accounts[0]})
					}).then(function(){
						// return FrescoCrowdsale.at(FrescoCrowdsale.address).setInvestorKYCWhitelist(accounts[1],true);
					});
};
