// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ActorAdmin} from "./Actors/ActorAdmin.t.sol";
import {ActorModAdmin} from "./Actors/ActorModAdmin.t.sol";
import {ActorStranger} from "./Actors/ActorStranger.t.sol";
import {Modulus} from "../../../src/Modulus/Modulus.sol";

// TODO: Template this file (using Storage.sol?)

contract ActorManager {
    // Admin Actor contract
    ActorAdmin internal s_actorAdmin;

    // ModAdmin Actor contract
    ActorModAdmin internal s_actorModAdmin;
    // ModAdmin Actor's actual address. This is here because the ActorAdmin sets this address on
    // the Modulus contract, and the ActorModAdmin needs to know what address to use to prank.
    address internal s_prankedModAdminAddress;

    // A Stranger Actor contract
    ActorStranger internal s_stranger;

    constructor() {
        s_actorAdmin = new ActorAdmin(this);
        s_actorModAdmin = new ActorModAdmin(this);
        s_prankedModAdminAddress = address(1234567);
        s_stranger = new ActorStranger(this);
    }

    // This sets the Modulus contract on each of the Actor contracts so that they know
    // where to call.
    function storeModulus(Modulus modulus) external {
        s_actorAdmin.storeModulus(modulus);
        s_actorModAdmin.storeModulus(modulus);
        s_stranger.storeModulus(modulus);
    }

    function getAdmin() external view returns (ActorAdmin) {
        return s_actorAdmin;
    }

    function getModAdmin() external view returns (ActorModAdmin) {
        return s_actorModAdmin;
    }

    function getPrankedModAdminAddress() external view returns (address) {
        return s_prankedModAdminAddress;
    }

    function getStranger() external view returns (ActorStranger) {
        return s_stranger;
    }

    error InvariantTestError();

    // This is only callable by the ActorAdmin contract, and is used to update the pranked
    // ModAdmin address, so that the ModAdmin contract knows what address to use to prank.
    function setPrankedModAdminAddress(address newAddress) external {
        if (msg.sender != address(s_actorAdmin)) revert InvariantTestError();
        s_prankedModAdminAddress = newAddress;
    }

}