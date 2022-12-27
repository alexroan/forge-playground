// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import {ActorAdmin} from "./Actors/ActorAdmin.t.sol";
import {ActorModAdmin} from "./Actors/ActorModAdmin.t.sol";
import {ActorStranger} from "./Actors/ActorStranger.t.sol";
import {Modulus} from "../../src/Modulus.sol";

contract ActorManager {
    ActorAdmin internal s_admin;

    ActorModAdmin internal s_modAdmin;
    address internal s_modAdminActualAddress;

    ActorStranger internal s_stranger;

    constructor() {
        s_admin = new ActorAdmin(this);
        s_modAdmin = new ActorModAdmin(this);
        s_modAdminActualAddress = address(1234567);
        s_stranger = new ActorStranger(this);
    }

    function storeModulus(Modulus modulus) external {
        s_admin.storeModulus(modulus);
        s_modAdmin.storeModulus(modulus);
        s_stranger.storeModulus(modulus);
    }

    function getAdmin() external returns (ActorAdmin) {
        return s_admin;
    }

    function getModAdmin() external returns (ActorModAdmin) {
        return s_modAdmin;
    }

    function getModAdminActualAddress() external returns (address) {
        return s_modAdminActualAddress;
    }

    function getStranger() external returns (ActorStranger) {
        return s_stranger;
    }

    error InvariantTestError();

    function setModAdminActualAddress(address newAddress) external returns (address) {
        if (msg.sender != address(s_admin)) revert InvariantTestError();
        s_modAdminActualAddress = newAddress;
    }

}