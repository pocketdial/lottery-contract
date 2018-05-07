pragma solidity ^0.4.21;

import "./Ownable.sol";
import "./SafeMath.sol";

contract Lottery is Ownable {
  using SafeMath for uint;

  event NewPlayer(address addressOfPlayer);
  event NewWinNumber(uint winNumber);
  event PickTheWinner(address winner);
  
  address[] private players;
  // uint ticketPrice;

  function buyTicket() external payable {
  //  require(msg.value == ticketPrice);
    players.push(msg.sender);
    emit NewPlayer(msg.sender); 
  }
  
  function _generateRandomNumber(uint _numberOfPlayers) private view returns (uint) {
    return (uint(keccak256(blockhash(block.number - 1), msg.sender)) % _numberOfPlayers);    
  }

  function play() public onlyOwner {
    // generate random number:
    require (players.length != 0);
    uint randNum = _generateRandomNumber(players.length);
    emit NewWinNumber(randNum);

    // choose the winner:
    address winner = players[randNum];
    emit PickTheWinner(winner);
    // winner.transfer(this.balance);

    // clear array
    delete players;
    players.length = 0;
  }
}
