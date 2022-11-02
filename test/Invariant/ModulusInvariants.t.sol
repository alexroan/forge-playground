// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import {Modulus} from "../../src/Modulus.sol";
import {Test} from "forge-std/Test.sol";
import {Constants} from "../Constants.t.sol";
import {InvariantsBase} from "./InvariantsBase.t.sol";
import {ActorModAdmin} from "./Actors/ActorModAdmin.t.sol";
import {ActorStranger} from "./Actors/ActorStranger.t.sol";

contract ModulusInvariants is Test, InvariantsBase, Constants {
    Modulus internal s_modulus;

    function setUp() public virtual {
        // Deploy actors
        ActorModAdmin modAdmin = new ActorModAdmin();
        ActorStranger stranger = new ActorStranger();

        // Deploy Modulus contract
        changePrank(address(OWNER));
        s_modulus = new Modulus(address(modAdmin));
        excludeContract(address(s_modulus));

        // Store the Modulus address on each of the actors
        modAdmin.storeModulus(s_modulus);
        stranger.storeModulus(s_modulus);

        // Add mod admin selectors to callable functions
        bytes4[] memory modAdminSelectors = new bytes4[](1);
        modAdminSelectors[0] = ActorModAdmin.setModDivisor.selector;
        addSelectors(address(modAdmin), modAdminSelectors);

        // Add stranger selectors to callable functions
        bytes4[] memory strangerSelectors = new bytes4[](1);
        strangerSelectors[0] = ActorStranger.mod.selector;
        addSelectors(address(stranger), strangerSelectors);
    }

    function invariant_gettersNeverRevert() public {
        s_modulus.getResult();
        s_modulus.getModDivisor();
        s_modulus.getModAdmin();
        s_modulus.getOwner();
    }

    function invariant_resultShouldAlwaysBeLessThanModDivisor() public {
        assertLe(s_modulus.getResult(), s_modulus.getModDivisor());
    }
}