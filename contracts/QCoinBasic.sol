pragma solidity ^0.4.4;

contract QCoinBasic {
  mapping (address => uint256) public balanceOf;
  mapping (address => mapping(address => uint256)) public allowance;
  string public standard = "QCoin V1.0";
  string public name;
  string public symbol;       // QC, ¥ $ ₩ £ € ...
  uint8 public decimal;
  uint256 public totalSupply;

  event TransferEvent(address indexed from, address indexed to, uint256 value);

  function QCoinBasic(uint256 initialSupply, string _name, string _symbol, uint8 decimalUnits) {
    balanceOf[msg.sender] = initialSupply;
    totalSupply = initialSupply;
    name = _name;
    decimal = decimalUnits;
    symbol = _symbol;
  }

  function transfer(address _to, uint256 _value) {
    //check available balance
    if(balanceOf[msg.sender] < _value) throw;
    //check overflow
    if(balanceOf[_to] + _value < balanceOf[_to]) throw;
    
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;

    TransferEvent(msg.sender, _to, _value);
  }

  function approve(address _spender, uint256 _value) returns (bool success) {
    allowance[msg.sender][_spender] = _value;
    return true;
  }

  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
    if(balanceOf[_from] < _value) throw;
    if(balanceOf[_to] + _value < balanceOf[_to]) throw;
    if(_value > allowance[_from][msg.sender]) throw;

    balanceOf[_from] -= _value;
    balanceOf[_to] += _value;
    allowance[_from][msg.sender] -= _value;

    TransferEvent(_from, _to, _value);
    return true;
  }

  function getBalance(address _addr) returns(uint256 balance){
    return balanceOf[_addr];
  }
}