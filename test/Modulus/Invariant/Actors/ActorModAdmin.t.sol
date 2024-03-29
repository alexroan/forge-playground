// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Test} from "forge-std/Test.sol";
import {Modulus} from "../../../../src/Modulus/Modulus.sol";
import {ActorManager} from "../ActorManager.t.sol";


contract ActorModAdmin is Test {
    Modulus internal s_modulus;

    ActorManager internal s_manager;
    constructor(ActorManager manager) {
        s_manager = manager;
    }

    function storeModulus(Modulus modulus) external {
        s_modulus = modulus;
    }

    function setModDivisor(uint256 modDivisor) external {
        if (modDivisor == 0) modDivisor = 1;
        changePrank(s_manager.getPrankedModAdminAddress());
        s_modulus.setModDivisor(modDivisor);
    }
}