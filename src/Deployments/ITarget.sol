// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface ITarget {
  function getInteger() external returns (uint256);
  function getDeployer() external returns (address);
}