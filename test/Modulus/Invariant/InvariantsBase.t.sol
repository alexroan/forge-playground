// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Test} from "forge-std/Test.sol";

contract InvariantsBase is Test {

    struct FuzzSelector {
        address addr;
        bytes4[] selectors;
    }

    address[] private s_excludeContracts;
    address[] private s_targetContracts;
    FuzzSelector[] private s_targetSelectors;
    address[] private s_targetSenders;

    constructor() {
        // https://github.com/foundry-rs/foundry/issues/2963
        s_targetSenders.push(address(1));
    }

    function excludeContracts() public view returns (address[] memory) {
        return s_excludeContracts;
    }

    function targetContracts() public view returns (address[] memory) {
        return s_targetContracts;
    }

    function targetSelectors() public view returns (FuzzSelector[] memory) {
        return s_targetSelectors;
    }

    function targetSenders() public view returns (address[] memory) {
        return s_targetSenders;
    }

    // To avoid calling auxiliary functions that are inherited but not under test
    // such as forge-std/Test.sol functions.
    function addSelectors(
        address newSelectorAddress,
        bytes4[] memory newSelectors
    ) public {
        s_targetSelectors.push(FuzzSelector(newSelectorAddress, newSelectors));
    }

    function addSender(address newSenderAddress) public {
        s_targetSenders.push(newSenderAddress);
    }

    // Utility function to exclude contracts that shouldn't be called
    function excludeContract(address excludedContractAddress) public {
        s_excludeContracts.push(excludedContractAddress);
    }
}
