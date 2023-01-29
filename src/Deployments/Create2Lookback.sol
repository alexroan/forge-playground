// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ITarget} from "./ITarget.sol";
import {IDeployer} from "./IDeployer.sol";

contract Create2LookbackTarget is ITarget {

  uint256 internal immutable i_integer;
  address internal immutable i_deployer;

  constructor() {
    i_deployer = msg.sender;
    i_integer = ILookback(i_deployer).getInteger();
  }

  function getInteger() external override returns (uint256){
    return i_integer;
  }
  
  function getDeployer() external override returns (address){
    return i_deployer;
  }

}

interface ILookback {

  function getInteger() external returns (uint256);

}

contract Create2LookbackDeployer is IDeployer, ILookback {

  uint256 private immutable i_integer;

  constructor(uint256 integer) {
    i_integer = integer;
  }

  function deploy(uint256 integer) external override returns (address target) {
    target = address(new Create2LookbackTarget{salt: bytes32("987654321")}());
  }

  function getInteger() external returns (uint256 integer) {
    return i_integer;
  }

}