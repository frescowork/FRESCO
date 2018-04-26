pragma solidity ^0.4.18;

import './IERC20.sol';
import '../../library/SafeMath.sol';
import '../../library/Ownable.sol';

contract FrescoToken is IERC20, Ownable { 
     
    using SafeMath for uint256;
    //public variables
    string public constant symbol="FRES"; 
    string public constant name="FRESCO";

    uint256 public constant decimals=18;
    uint256 public totalSupply = 500000000 * 10 ** uint(decimals);

    //map the addresses
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    // To add crowdsale contract for authorized distributer while in transfer Lock
    uint256 public transferLockTimestamp;
    mapping(address => bool) authorizedLockedTransfer;

    modifier checkTransferAllowed {
        if(now < transferLockTimestamp){
            require(authorizedLockedTransfer[msg.sender]);
        }
        _;
    }

    function FrescoToken() public payable {
        balances[msg.sender] = totalSupply;
    }

    function balanceOf(address _owner) constant returns(uint256 balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) returns(bool success) {
        //require is the same as an if statement = checks 
        require(_to != address(0));
        require(balances[msg.sender] >= _value && _value > 0 );
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);
        //updating the spenders balance 
        balances[_from] = balances[_from].sub(_value); 
        balances[_to] = balances[_to].add(_value); 
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        Transfer(_from, _to, _value); 
        return true;
    }

    function approve(address _spender, uint256 _value) returns(bool success) {
            
        //if above require is true,approve the spending 
        allowed[msg.sender][_spender] = _value; 
        Approval(msg.sender, _spender, _value); 
        return true;
    }

    function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
        
        return allowed[_owner][_spender];
    }
    
    event Transfer(address indexed_from, address indexed_to, uint256 _value);
    event Approval(address indexed_owner, address indexed_spender, uint256 _value);
    
}