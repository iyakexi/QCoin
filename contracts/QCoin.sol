pragma solidity ^0.4.4;

import './Admined.sol';
import './QCoinBasic.sol';

contract QCoin is Admined, QCoinBasic {

  mapping(address => bool) public frozenAccount;
  uint256 minimumBalanceForAccounts = 5 finney;
  uint256 public sellPrice;
  uint256 public buyPrice;

  event FrozenAccountEvent(address target, bool frozen);

  function QCoin(uint256 initialSupply, string _name, string _symbol, 
    uint8 decimalUnits, address _admin) QCoinBasic(0, _name, _symbol, decimalUnits) {
    totalSupply = initialSupply;
    if(_admin != 0) {
      admin = _admin;
    } else {
      admin = msg.sender;
    }
    balanceOf[admin] = initialSupply;
    totalSupply = initialSupply;
  }

  function mintToken(address target, uint256 mintedAmout) onlyAdmin {
    balanceOf[target] += mintedAmout;
    totalSupply += mintedAmout;
    TransferEvent(0, this, mintedAmout);
    TransferEvent(this, target, mintedAmout);
  }

  function freezeAccount(address target, bool freeze) onlyAdmin {
    frozenAccount[target] = freeze;
    FrozenAccountEvent(target, freeze);
  }

function transfer(address _to, uint256 _value) {
    if(msg.sender.balance < minimumBalanceForAccounts)
		  sell((minimumBalanceForAccounts - msg.sender.balance)/sellPrice);

    if(frozenAccount[msg.sender]) throw;
    //check available balance
    if(balanceOf[msg.sender] < _value) throw;
    //check overflow
    if(balanceOf[_to] + _value < balanceOf[_to]) throw;
    
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;

    TransferEvent(msg.sender, _to, _value);
  }

  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
    if(frozenAccount[_from]) throw;
    if(balanceOf[_from] < _value) throw;
    if(balanceOf[_to] + _value < balanceOf[_to]) throw;
    if(_value > allowance[_from][msg.sender]) throw;

    balanceOf[_from] -= _value;
    balanceOf[_to] += _value;
    allowance[_from][msg.sender] -= _value;

    TransferEvent(_from, _to, _value);
    return true;
  }

  function setPrice(uint256 _sellPrice, uint256 _buyPrice) onlyAdmin {
    sellPrice = _sellPrice;
    buyPrice = _buyPrice;
  }

  function buy() payable {
		uint256 amount = (msg.value/(1 ether)) / buyPrice;
		if(balanceOf[this] < amount) throw;
		balanceOf[msg.sender] += amount;
		balanceOf[this] -= amount;
		TransferEvent(this, msg.sender, amount);
	}

	function sell(uint256 amount) {
		if(balanceOf[msg.sender] < amount) throw;
		balanceOf[this] += amount;
		balanceOf[msg.sender] -= amount;
		if(!msg.sender.send(amount * sellPrice * 1 ether)){
			throw;
		} else {
			TransferEvent(msg.sender, this, amount);
		}
	}

}