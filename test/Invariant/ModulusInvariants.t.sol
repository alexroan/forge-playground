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

// TODO: Template this file as much as possible with the manager

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
        ActorAdmin actorAdmin = s_manager.getAdmin();
        ActorModAdmin actorModAdmin = s_manager.getModAdmin();
        ActorStranger actorStranger = s_manager.getStranger();

        // Deploy Modulus contract
        changePrank(address(actorAdmin));
        s_modulus = new Modulus(s_manager.getPrankedModAdminAddress());
        excludeContract(address(s_modulus));

        // Store the Modulus address on each of the actors
        s_manager.storeModulus(s_modulus);

        // Add admin selectors to callable functions
        bytes4[] memory adminSelectors = new bytes4[](1);
        adminSelectors[0] = ActorAdmin.setModAdmin.selector;
        addSelectors(address(actorAdmin), adminSelectors);        

        // Add mod admin selectors to callable functions
        bytes4[] memory modAdminSelectors = new bytes4[](1);
        modAdminSelectors[0] = ActorModAdmin.setModDivisor.selector;
        addSelectors(address(actorModAdmin), modAdminSelectors);

        // Add stranger selectors to callable functions
        bytes4[] memory strangerSelectors = new bytes4[](1);
        strangerSelectors[0] = ActorStranger.mod.selector;
        addSelectors(address(actorStranger), strangerSelectors);
    }

    function invariant_gettersNeverRevert() public view {
        s_modulus.getResult();
        s_modulus.getModDivisor();
        s_modulus.getModAdmin();
        s_modulus.getOwner();
    }

    function invariant_resultShouldAlwaysBeLessThanModDivisor() public {
        assertLt(s_modulus.getResult(), s_modulus.getModDivisor());
    }
}