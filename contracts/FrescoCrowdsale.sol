
pragma solidity ^0.4.18;

import "./CrowdsaleBase.sol";

contract FrescoCrowdsale is CrowdsaleBase {

  mapping (address => bool) public KYCWhitelist;
  address public APIAdminAddress;
  uint public crowdsaleTokenCap;
  bool public checkKYC;

  // Address early participation whitelist status changed
  event Whitelisted(address addr, bool status);

  function FrescoCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _crowdsaleTokenCap) CrowdsaleBase(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
    crowdsaleTokenCap = _crowdsaleTokenCap;
    checkKYC = false;
  }

    /// onlyAPIAdmin Access modifier for APIAdmin-only functionality
  modifier onlyAPIAdmin() {
    require(msg.sender == APIAdminAddress);
    _;
  }

  function() payable {
    buy();
  }
  /**
   * The basic entry point to participate the crowdsale process.
   *
   * Pay for funding, get invested tokens back in the sender address.
   */
  function buy() public payable 
  {
    if(checkKYC && !KYCWhitelist[msg.sender]) {
        throw;
    }
    investInternal(msg.sender, 0);
  }

  function setKYCCheck(bool _bSet) public onlyOwner
  {
    checkKYC = _bSet;
  }

    /// setAPIAdmin Assigns a new address to act as the APIAdmin. Only available to Owner.
    /// @param _newAPIAdmin The address of the new APIAdmin
  function setAPIAdmin(address _newAPIAdmin) public onlyOwner 
  {
    require(_newAPIAdmin != address(0));
    APIAdminAddress = _newAPIAdmin;
  }

  function setInvestorKYCWhitelist(address addr, bool status) public onlyAPIAdmin 
  {
      KYCWhitelist[addr] = status;
      Whitelisted(addr, status);
  }

  function checkKYCWhitelist(address addr) public view returns (bool){
    if(KYCWhitelist[addr]){
      return true;
    }
    return false;
  }
  
  function assignTokens(address receiver, uint tokenAmount) internal{
      token.transferFrom(multisigWallet, receiver, tokenAmount);
  }

  function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken){
      limitBroken = tokensSoldTotal > crowdsaleTokenCap;
      return;
  }

  function isCrowdsaleFull() public constant returns (bool)
  {
    return tokensSold>=crowdsaleTokenCap;
  }
}