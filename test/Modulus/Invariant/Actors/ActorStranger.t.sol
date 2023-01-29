// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Test} from "forge-std/Test.sol";
import {Modulus} from "../../../../src/Modulus/Modulus.sol";
import {ActorManager} from "../ActorManager.t.sol";


contract ActorStranger is Test {
    Modulus internal s_modulus;

    ActorManager internal s_manager;
    constructor(ActorManager manager) {
        s_manager = manager;
    }

    function storeModulus(Modulus modulus) external {
        s_modulus = modulus;
    }

    function mod(uint256 numerator) external {
        s_modulus.mod(numerator);
    }
}