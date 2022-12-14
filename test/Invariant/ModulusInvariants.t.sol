// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import {Modulus} from "../../src/Modulus.sol";
import {Test} from "forge-std/Test.sol";
import {Constants} from "../Constants.t.sol";
import {InvariantsBase} from "./InvariantsBase.t.sol";
import {ActorModAdmin} from "./Actors/ActorModAdmin.t.sol";
import {ActorStranger} from "./Actors/ActorStranger.t.sol";
import {ActorAdmin} from "./Actors/ActorAdmin.t.sol";
import {ActorManager} from "./ActorManager.t.sol";

contract ModulusInvariants is Test, InvariantsBase, Constants {
    Modulus internal s_modulus;

    // Actor manager keeps track of state so that runs can divert
    // to other actors or functions to prevent known revert paths.
    // When an actor calls a function and changes the state on the
    // Modulus contract, the actor must make sure the manager knows
    // about it.
    ActorManager internal s_manager;

    function setUp() public virtual {
        s_manager = new ActorManager();
        excludeContract(address(s_manager));

        // Deploy actors
        ActorAdmin admin = s_manager.getAdmin();
        ActorModAdmin modAdmin = s_manager.getModAdmin();
        ActorStranger stranger = s_manager.getStranger();

        // Deploy Modulus contract
        changePrank(address(admin));
        s_modulus = new Modulus(s_manager.getModAdminActualAddress());
        excludeContract(address(s_modulus));

        // Store the Modulus address on each of the actors
        s_manager.storeModulus(s_modulus);

        // Add admin selectors to callable functions
        bytes4[] memory adminSelectors = new bytes4[](1);
        adminSelectors[0] = ActorAdmin.setModAdmin.selector;
        addSelectors(address(admin), adminSelectors);        

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