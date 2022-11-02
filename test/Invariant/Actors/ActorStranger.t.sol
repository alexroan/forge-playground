// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import {Test} from "forge-std/Test.sol";
import {Modulus} from "../../../src/Modulus.sol";

contract ActorStranger is Test {
    Modulus internal s_modulus;

    function storeModulus(Modulus modulus) external {
        s_modulus = modulus;
    }

    function mod(uint256 numerator) external {
        s_modulus.mod(numerator);
    }
}