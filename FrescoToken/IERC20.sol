pragma solidity ^0.4.20;

import'./IERC20Basic.sol';

/**
*@titleERC20interface
*@devseehttps://github.com/ethereum/EIPs/issues/20
*/

contract IERC20 is ERC20Basic
{
    function allowance(address owner,address spender) public constant returns(uint256);
    function transferFrom(address from,address to,uint256 value) public returns(bool);
    function approve(address spender,uint256 value) public returns(bool);
    event Approval(address indexedowner,address indexedspender,uint256 value);
}