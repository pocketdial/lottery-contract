pragma solidity ^0.4.21;

// import "./Ownable.sol";
// import "./SafeMath.sol";

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    if (a == 0) {
      return 0;
    }
    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}

contract Lottery is Ownable {
  using SafeMath for uint;

  event NewPlayer(address addressOfPlayer);
  event NewWinNumber(uint winNumber);
  event PickTheWinner(address winner);
  
  address[] private players;
  uint ticketPrice = 0.01 ether;
  uint feeShare = 10;
  // uint fee = 0.01 ether;

  function buyTicket() external payable {
    require(msg.value == ticketPrice);
    players.push(msg.sender);
    emit NewPlayer(msg.sender); 
  }
  
  function _generateRandomNumber(uint _numberOfPlayers) private view returns (uint) {
    return (uint(keccak256(blockhash(block.number - 1), msg.sender)) % _numberOfPlayers);    
  }

  function _takeFee() private {    
    owner.transfer(address(this).balance.div(feeShare));
  }

  function play() public onlyOwner {
    // generate random number:
    require (players.length > 1);
    uint randNum = _generateRandomNumber(players.length);
    emit NewWinNumber(randNum);

    // choose the winner:
    address winner = players[randNum];
    emit PickTheWinner(winner);
    _takeFee();
    winner.transfer(address(this).balance);    

    // clear array
    delete players;
    players.length = 0;
  }

  function Lottery() {
    _
  }
}