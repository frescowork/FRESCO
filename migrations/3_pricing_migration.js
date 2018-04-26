var BigNumber = web3.BigNumber;
var MilestonePricing = artifacts.require("./contracts/MilestonePricing.sol");
var SafeMathLib = artifacts.require("./contracts/SafeMathLib.sol");

var startPresale = 1521104400; // Thursday, 15 March 2018 09:00:00
//
var startSale = 1521622800; // Wednesday, 21 March 2018 09:00:00
var endSale = 1523826000; // Sunday, 15 April 2018 21:00:00

var rate = 5000; // Tokens per ETH
var ratePreSale = 6500; // Tokens per ETH
var milestones = [startPresale,
                ratePreSale,
                startSale,
                rate,
                endSale,
                0];
module.exports = function(deployer, network, accounts) {
	// MilestonePricing(uint[] _milestones) {
    deployer.deploy(SafeMathLib);
    deployer.link(SafeMathLib, MilestonePricing);
    console.log(milestones);
	deployer.deploy(MilestonePricing, milestones);
};
