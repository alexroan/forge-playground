// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract Modulus {
    event ModAdminSet(address indexed previous, address indexed modAdmin);
    event ModDivisorSet(uint256 previous, uint256 modDivisor);
    event ResultReset();
    event Result(uint256 n, uint256 modDivisor, uint256 result);

    error OnlyOwner(address expected, address actual);
    error OnlyModAdmin(address expected, address actual);
    error ModDivisorCannotBeZero();

    /// @notice Owner of the contract - Can set the modAdmin
    address private immutable i_owner;
    /// @notice modAdmin can set the s_modDivisor
    address private s_modAdmin;
    /// @notice modDivisor used in mod calculation
    uint256 private s_modDivisor;
    /// @notice result of the last mod calulation
    uint256 private s_result;

    constructor(address modAdmin) {
        i_owner = msg.sender;
        s_modAdmin = modAdmin;
        s_modDivisor = 1;
    }

    function setModAdmin(address modAdmin) external onlyOwner() {
        address previous = s_modAdmin;
        s_modAdmin = modAdmin;
        emit ModAdminSet(previous, modAdmin);
    }

    function setModDivisor(uint256 modDivisor) external onlyModAdmin() {
        if (modDivisor == 0) revert ModDivisorCannotBeZero();
        uint256 previous = s_modDivisor;
        s_modDivisor = modDivisor;
        emit ModDivisorSet(previous, modDivisor);
        s_result = 0;
        emit ResultReset();
    }

    function mod(uint256 n) external {
        uint256 modDivisor = s_modDivisor;
        uint256 result = n % modDivisor;
        s_result = result;
        emit Result(n, modDivisor, result);
    }

    function getOwner() external view returns (address owner) {
        owner = i_owner;
    }

    function getModAdmin() external view returns (address modAdmin) {
        modAdmin = s_modAdmin;
    }

    function getModDivisor() external view returns (uint256 modDivisor) {
        modDivisor = s_modDivisor;
    }

    function getResult() external view returns (uint256 result) {
        result = s_result;
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert OnlyOwner(i_owner, msg.sender);
        }
        _;
    }

    modifier onlyModAdmin() {
        if (msg.sender != s_modAdmin) {
            revert OnlyModAdmin(s_modAdmin, msg.sender);
        }
        _;
    }
}
