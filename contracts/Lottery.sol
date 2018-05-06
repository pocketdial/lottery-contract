pragma solidity ^0.4.21;

import "./Ownable.sol";
import "./SafeMath.sol";

contract Lottery is Ownable {
  using SafeMath for uint;

  // TODO events
  
  address[] private players;

  function buyTicket() public {
    players.push(msg.sender);
  }
  
  function _generateRandomNumber(uint _numberOfPlayers) private view returns (uint) {
    return (uint(keccak256(blockhash(block.number - 1), msg.sender)) % _numberOfPlayers);
  }

  function play() public onlyOwner{
    require (players.length != 0);
    _generateRandomNumber(players.length);

    // pick the winner

    // clear array
    delete players;
    players.length = 0;
  }
}
