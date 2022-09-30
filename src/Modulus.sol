// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Modulus {
    uint256 public number;

    function mod20(uint256 n) public {
        number = n % 20;
    }
}
