var express = require('express');
var fs = require('fs');
var app = express();
var config = require('./config.json')

// ====================== Web3 ==========================
var Web3 = require('web3');
var web3Provider;
if (typeof web3 !== 'undefined') {
    web3Provider = web3.currentProvider;
} else {
    // If no injected web3 instance is detected, fall back to Ganache
    web3Provider = new Web3.providers.HttpProvider(config.WEB3_PROVIDER);
}
var web3 = new Web3(web3Provider);

// ====================== Truffle Contract ==========================
var contract = require("truffle-contract");
var FrescoCrowdsale;
fs.readFile("./FrescoCrowdsale.json",'utf8', function read(err, data) {
    if (err) {
        throw err;
    }
    content = JSON.parse(data);
    FrescoCrowdsale = contract(content);
    console.log("Conneting to smart contract..");
    console.log(FrescoCrowdsale.contractName);
    FrescoCrowdsale.setProvider(web3Provider);
    FrescoCrowdsale.at(config.CROWDSALE_CONTRACT_ADDR).then(function(instance) {
        FrescoCrowdsale.web3.eth.defaultAccount=FrescoCrowdsale.web3.eth.coinbase;
        console.log("gettting state of contract..");
        // console.log(instance.getState());
        return instance.getState();
     }).then(function(state){
            console.log("State: " + state);
     });
});

// ====================== Server ==========================
//app.use(express.body());
var bodyParser = require('body-parser');
app.use(bodyParser.json()); // support json encoded bodies
app.use(bodyParser.urlencoded({	extended: true })); // support encoded bodies

app.get('/', function(req, res){
    console.log('GET /')
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end("Hello...");
});

// ==============================================================
// REQUEST = {"sec": "E3A91B527A7EDA4FD2C116E946588", "addr" : ""}
app.post('/', function(req, res){
    console.log('POST /');
    console.dir(req.body);
    var secret = req.body.sec;
    var ethAddr = req.body.addr;
    console.log(secret == config.SECRET);
    console.log(ethAddr.length == 42);
    if(secret == config.SECRET && ethAddr.length == 42) {
        console.log("Adding in whitelist: " + ethAddr);
        // Call localhost web3 for adding address in whitelist.
        FrescoCrowdsale.at(config.CROWDSALE_CONTRACT_ADDR).then(function(instance) {
            return instance.setInvestorKYCWhitelist(ethAddr, true);
        }).then(function(){
            console.log("KYC for User done: " + ethAddr);
             res.json({"res":"SUCCESS"});
         }).catch(function (ex) {
             var err = "KYC for user "+ethAddr+" failed: " + ex;
            console.log(err);
            res.json({"res":"FAIL", "err" : err});
        }); ;
    }
    else {
        res.json({"res":"FAIL", "err" : "Invalid inputs.."});
    }
});

app.listen(config.PORT, config.HOST);
console.log('Listening at http://localhost:' + config.PORT)
