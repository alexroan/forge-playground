// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import {Test} from "forge-std/Test.sol";
import {Modulus} from "../../../src/Modulus.sol";
import {ActorManager} from "../ActorManager.t.sol";

contract ActorAdmin is Test {
    Modulus internal s_modulus;

    ActorManager internal s_manager;
    constructor(ActorManager manager) {
        s_manager = manager;
    }

    function storeModulus(Modulus modulus) external {
        s_modulus = modulus;
    }

    function setModAdmin(uint160 seed) external {
        address newModAdmin = address(seed);
        s_modulus.setModAdmin(newModAdmin);
        s_manager.setModAdminActualAddress(newModAdmin);
    }
}