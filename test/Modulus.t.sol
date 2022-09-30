// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Modulus.sol";

contract ModulusTest is Test {
    Modulus public modulus;

    function setUp() public virtual {
        modulus = new Modulus();
    }

    // Unit test
    function testMod20() public {
        uint256 numerator = 50;
        uint256 expected = numerator % 20;

        modulus.mod20(numerator);
        assertEq(modulus.number(), expected);
    }

    // Fuzz test
    function testMod20(uint256 numerator) public {
        uint256 expected = numerator % 20;

        modulus.mod20(numerator);
        assertEq(modulus.number(), expected);
    }
}

contract ModulusInvariants is ModulusTest {
    // Special array used by forge for invariant testing
    address[] public targetContracts;

    function setUp() public override {
        ModulusTest.setUp();

        targetContracts.push(address(modulus));
    }

    // Invariant test
    function invariantNumberIsLessThan20() public {
        assertLt(modulus.number(), 20);
    }
}
