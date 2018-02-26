pragma solidity ^0.4.20;

import './IERC20.sol';
import './SafeMath.sol';

contract FrescoToken is IERC20 { 
     
    using SafeMath for uint256;
    //public variables
    string public constant symbol="FRES"; 
    string public constant name="FRESCO";
    bool private paused = false;
    address public _owner;
    uint256 public constant decimals=18;
    uint256 public tokenExchangeRate = 5000;
    uint256 public totalSupply = 500000000 * 10 ** uint(decimals);
    uint256 public preSaleStartDate = 1521363600;//03/15/2018 9AM UTC
    uint256 public preSaleEndDate = 1521579600;//03/20/2018 9PM
    uint256 public mainSaleStartDate = 1521622800;//03/21/2018 9AM UTC
    uint256 public mainSaleEndDate = 1523826000;//04/15/2018 9PM UTC
    //map the addresses
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    //create token function = check
    modifier onlyOwner {
        require(msg.sender == _owner);
        _;
    }
    
    modifier contractActive {
        require(paused == false);
        _;
    }
    function FrescoToken(address _holder,address _foundation,address _team) public payable{
        require(_holder != 0x0);
        require(_foundation != 0x0);
        require(_team != 0x0);   
        _owner = _holder;
        balances[_owner] = totalSupply.mul(60).div(100);
        balances[_foundation] = totalSupply.mul(20).div(100);
        balances[_team] = totalSupply.mul(20).div(100);
    }
    
    function buyTokens()
        external 
        payable
        contractActive
        returns (uint256 amount)
        {
            amount = calcToken(msg.value);
            require(now > 1521363600 && now < 1523826000);
            require(msg.value > 0);
            require(balanceOf(_owner) >= amount); 
            balances[_owner] = balances[_owner].sub(amount);
            balances[msg.sender] = balances[msg.sender].add(amount);
            return amount;
        }
    function pauseContract() public onlyOwner {
        paused = true;
    }
    function unpauseContract() public onlyOwner {
        paused = false;
    } 
  /// @notice to unpause functions
   
    function setPrice(uint256 value) 
        onlyOwner
        {
            tokenExchangeRate = value;
        }
    function calcToken(uint256 value) 
        internal
        returns(uint256 amount){
             if(now > mainSaleStartDate ) tokenExchangeRate = 6500;
             amount =  tokenExchangeRate.mul(value);
             return amount;
        }
    function balanceOf(address _owner) 
        constant 
        returns(uint256 balance) {
            return balances[_owner];
        }

    function transfer(address _to, uint256 _value) 
        returns(bool success) {
            //require is the same as an if statement = checks 
            require(balances[msg.sender] >= _value && _value > 0 );
            balances[msg.sender] = balances[msg.sender].sub(_value);
            balances[_to] = balances[_to].add(_value);
            Transfer(msg.sender, _to, _value);
            return true;
        }

    function transferFrom(address _from, address _to, uint256 _value) 
        returns (bool success) {
            
            //updating the spenders balance 
            balances[_from] = balances[_from].sub(_value); 
            balances[_to] = balances[_to].add(_value); 
            Transfer(_from, _to, _value); 
            return true;
        }
     function approve(address _spender, uint256 _value) 
        returns(bool success) {
            
            //if above require is true,approve the spending 
            allowed[msg.sender][_spender] = _value; 
            Approval(msg.sender, _spender, _value); 
            return true;
        }

    function allowance(address _owner, address _spender) 
        constant 
        returns(uint256 remaining) {
            
            return allowed[_owner][_spender];
        }
    
    event Transfer(address indexed_from, address indexed_to, uint256 _value);
    event Approval(address indexed_owner, address indexed_spender, uint256 _value);
    
}