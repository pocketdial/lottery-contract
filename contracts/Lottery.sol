pragma solidity ^0.4.21;

import "./Ownable.sol";
import "./SafeMath.sol";

contract Lottery is Ownable {
  using SafeMath for uint;
  
  address public owner;
  uint public last_completed_migration;

  function buyTicket() public {
    last_completed_migration = completed;
  }
  
  function _generateRandomNumber(uint _numberOfPlayers) private view returns (uint) {
    uint rand = uint(keccak256(_str));
    return rand % dModulus;
  }

  function chooseTheWinner() public onlyOwner{
    Migrations upgraded = Migrations(new_address);
    upgraded.setCompleted(last_completed_migration);
  }
}
