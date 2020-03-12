pragma solidity >=0.4.21 <=0.7.0;

import "./PetroToken.sol";

contract PetroTokenICO {
  address payable admin;
  PetroToken public tokenContract;
  uint256 public tokenPrice;
  uint256 public tokensSold;

  event Sell(address _buyer, uint256 _amount);

  constructor (PetroToken _tokenContract, uint256 _tokenPrice) public {
    admin = msg.sender;
    tokenContract = _tokenContract;
    tokenPrice = _tokenPrice;
  }

  function multiply(uint x, uint y) internal pure returns (uint z) {
    require(y == 0 || (z = x * y) / y == x, "Multiplication failure!");
  }

  function buyTokens(uint256 _numberOfTokens) public payable {
    require(msg.value == multiply(_numberOfTokens, tokenPrice), "Could not multiply!");
    require(tokenContract.balanceOf(address(this)) >= _numberOfTokens, "Insufficient token!");
    require(tokenContract.transfer(msg.sender, _numberOfTokens), "Transfer failed!");

    tokensSold += _numberOfTokens;

    emit Sell(msg.sender, _numberOfTokens);
  }

  function endSale() public {
    require(msg.sender == admin, "You are not the admin!");
    require(tokenContract.transfer(admin, tokenContract.balanceOf(address(this))), "Transfer failed");

    // Just transfer the balance to the admin
    admin.transfer(address(this).balance);
  }
}