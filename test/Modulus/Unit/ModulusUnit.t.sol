// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Test} from "forge-std/Test.sol";
import {Modulus} from "../../../src/Modulus/Modulus.sol";
import {Constants} from "../Constants.t.sol";

contract ModulusUnit is Test, Constants {
    Modulus internal s_modulus;

    function setUp() public virtual {
        changePrank(OWNER);
        s_modulus = new Modulus(MOD_ADMIN);
        changePrank(MOD_ADMIN);
        s_modulus.setModDivisor(MOD_DIVISOR_1);
        changePrank(OWNER);
    }

    // ==========================================================================
    // CONSTRUCTOR
    // ==========================================================================

    function test_constructor() public {
        assertEq(s_modulus.getOwner(), OWNER);
        assertEq(s_modulus.getModAdmin(), MOD_ADMIN);
    }

    // ==========================================================================
    // SET MOD ADMIN
    // ==========================================================================

    function test_setModAdmin_onlyOwner_reverts() public {
        changePrank(STRANGER);
        vm.expectRevert(abi.encodeWithSelector(Modulus.OnlyOwner.selector, OWNER, STRANGER));
        s_modulus.setModAdmin(STRANGER);
    }

    event ModAdminSet(address indexed previous, address indexed modAdmin);
    function test_setModAdmin() public {
        vm.expectEmit(true, true, true, false);
        emit ModAdminSet(s_modulus.getModAdmin(), STRANGER);
        s_modulus.setModAdmin(STRANGER);
        assertEq(s_modulus.getModAdmin(), STRANGER);
    }

    // ==========================================================================
    // SET MOD DIVISOR
    // ==========================================================================

    function test_setModDivisor_onlyModAdmin_reverts() public {
        changePrank(STRANGER);
        vm.expectRevert(abi.encodeWithSelector(Modulus.OnlyModAdmin.selector, MOD_ADMIN, STRANGER));
        s_modulus.setModDivisor(123);
    }

    function test_setModDivisor_zeroValue_reverts() public {
        changePrank(MOD_ADMIN);
        vm.expectRevert(Modulus.ModDivisorCannotBeZero.selector);
        s_modulus.setModDivisor(0);
    }

    event ModDivisorSet(uint256 previous, uint256 modDivisor);
    event ResultReset();
    function test_setModDivisor() public {
        changePrank(MOD_ADMIN);
        vm.expectEmit(true, false, false, false);
        emit ModDivisorSet(s_modulus.getModDivisor(), MOD_DIVISOR_2);
        vm.expectEmit(true, false, false, false);
        emit ResultReset();
        s_modulus.setModDivisor(MOD_DIVISOR_2);
        assertEq(s_modulus.getModDivisor(), MOD_DIVISOR_2);
    }

    // ==========================================================================
    // MOD
    // ==========================================================================
    event Result(uint256 n, uint256 modDivisor, uint256 result);
    function test_mod() public {
        uint256 numerator = 50;
        uint256 expected = numerator % MOD_DIVISOR_1;

        vm.expectEmit(true, false, false, false);
        emit Result(numerator, MOD_DIVISOR_1, expected);
        s_modulus.mod(numerator);
        assertEq(s_modulus.getResult(), expected);
    }
}
