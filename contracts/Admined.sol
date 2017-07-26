pragma solidity ^0.4.4;

contract Admined {
  address public admin;

  function Admined() {
    admin = msg.sender;
  }

  modifier onlyAdmin() {
    if(msg.sender != admin) throw;
    _;
  }

  function transferAdminship(address newAdmin) onlyAdmin {
    admin = newAdmin;
  }
}