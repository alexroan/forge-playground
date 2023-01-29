// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Test} from "forge-std/Test.sol";
import {IDeployer} from "../../src/Deployments/IDeployer.sol";
import {VanillaDeployer} from "../../src/Deployments/Vanilla.sol";
import {BasicCreate2Deployer} from "../../src/Deployments/BasicCreate2.sol";
import {Create2LookbackDeployer} from "../../src/Deployments/Create2Lookback.sol";


contract DeploymentGasTest is Test {

  IDeployer internal immutable i_deployer;
  uint256 internal constant INTEGER_VALUE = 12345678;

  constructor(IDeployer deployer) {
    i_deployer = deployer;
  }

  function testGas() public {
    i_deployer.deploy(INTEGER_VALUE);
  }

}

contract VanillaDeploymentGasTest is DeploymentGasTest {
  constructor() DeploymentGasTest(new VanillaDeployer()) {}
}

contract BasicCreate2DeploymentGasTest is DeploymentGasTest {
  constructor() DeploymentGasTest(new BasicCreate2Deployer()) {}
}

contract Create2LookbackDeploymentGasTest is DeploymentGasTest {
  constructor() DeploymentGasTest(new Create2LookbackDeployer(INTEGER_VALUE)) {}
}