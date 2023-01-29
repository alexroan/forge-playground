// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface IDeployer {
  function deploy(uint256 integer) external returns (address target);
}