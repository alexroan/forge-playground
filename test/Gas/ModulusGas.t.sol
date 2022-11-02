// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import {Test} from "forge-std/Test.sol";
import {Modulus} from "../../src/Modulus.sol";
import {Constants} from "../Constants.t.sol";

/// @notice Prefixed with GAS_ so all raw gas costs are clumped together in .gas-snapshot
contract GAS_Modulus_Base is Test, Constants {
    Modulus internal s_modulus;

    function setUp() public virtual {
        changePrank(OWNER);
        s_modulus = new Modulus(MOD_ADMIN);
        changePrank(MOD_ADMIN);
        s_modulus.setModDivisor(MOD_DIVISOR_1);
        changePrank(STRANGER);
        s_modulus.mod(1);
    }
}

contract GAS_ModulusGas_Owner is GAS_Modulus_Base {
    function setUp() public virtual override{
        GAS_Modulus_Base.setUp();
        changePrank(OWNER);
    }

    function test_setModAdmin() public {
        s_modulus.setModAdmin(STRANGER);
    }
}

contract GAS_ModulusGas_ModAdmin is GAS_Modulus_Base {
    function setUp() public virtual override {
        GAS_Modulus_Base.setUp();
        changePrank(MOD_ADMIN);
    }

    function test_setModDivisor() public {
        s_modulus.setModDivisor(MOD_DIVISOR_2);
    }
}

contract GAS_ModulusGas_Stranger is GAS_Modulus_Base {
    function test_mod() public {
        s_modulus.mod(123);
    }

    function test_getOwner() public view {
        s_modulus.getOwner();
    }

    function test_getModDivisor() public view {
        s_modulus.getModDivisor();
    }

    function test_getResult() public view {
        s_modulus.getResult();
    }
}