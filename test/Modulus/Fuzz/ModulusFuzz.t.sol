// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Test} from "forge-std/Test.sol";
import {Modulus} from "../../../src/Modulus/Modulus.sol";
import {Constants} from "../Constants.t.sol";

contract ModulusFuzz is Test, Constants {
    Modulus internal s_modulus;

    function setUp() public virtual {
        changePrank(OWNER);
        s_modulus = new Modulus(MOD_ADMIN);
        changePrank(MOD_ADMIN);
        s_modulus.setModDivisor(MOD_DIVISOR_1);
    }

    function test_mod_resultIsAlwaysLessThanModDivisor(uint256 modDivisor, uint256 numerator) public {
        vm.assume(modDivisor > 0);
        s_modulus.setModDivisor(modDivisor);
        s_modulus.mod(numerator);
        assertLt(s_modulus.getResult(), modDivisor);
    }
}