pragma solidity ^0.4.20;

/**
*@titleIERC20Basic
*@devSimplerversionofERC20interface
*@devseehttps://github.com/ethereum/EIPs/issues/179
*/

contract ERC20Basic
{
    uint256 public totalSupply;
    function balanceOf(address who) public constant returns(uint256);
    function transfer(address to,uint256 value) public returns(bool);
    event Transfer(address indexedfrom,address indexedto,uint256 value);
}