// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import {Test} from "forge-std/Test.sol";
import {Modulus} from "../../../src/Modulus.sol";

contract ActorModAdmin is Test {
    Modulus internal s_modulus;

    function storeModulus(Modulus modulus) external {
        s_modulus = modulus;
    }

    function setModDivisor(uint256 modDivisor) external {
        if (modDivisor == 0) modDivisor = 1;
        s_modulus.setModDivisor(modDivisor);
    }
}