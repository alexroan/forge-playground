// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ITarget} from "./ITarget.sol";
import {IDeployer} from "./IDeployer.sol";

contract VanillaTarget is ITarget {

  uint256 internal immutable i_integer;
  address internal immutable i_deployer;

  constructor(uint256 integer) {
    i_integer = integer;
    i_deployer = msg.sender;
  }

  function getInteger() external override returns (uint256){
    return i_integer;
  }
  
  function getDeployer() external override returns (address){
    return i_deployer;
  }
}

contract VanillaDeployer is IDeployer{

  function deploy(uint256 integer) external override returns (address target) {
    target = address(new VanillaTarget(integer));
  }

}