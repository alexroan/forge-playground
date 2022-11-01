// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

contract Modulus {
    event ModAdminSet(address indexed previous, address indexed modAdmin);
    event ModDivisorSet(uint256 previous, uint256 modDivisor);
    event Result(uint256 n, uint256 modDivisor, uint256 result);

    error OnlyOwner(address expected, address actual);
    error OnlyModAdmin(address expected, address actual);

    /// @notice Owner of the contract - Can set the modAdmin
    address private s_owner;
    /// @notice modAdmin can set the mod value
    address private s_modAdmin;
    /// @notice modDivisor used in mod calculation
    uint256 private s_modDivisor;
    /// @notice result of the last mod calulation
    uint256 private s_result;

    constructor(address modAdmin) {
        s_owner = msg.sender;
        s_modAdmin = modAdmin;
    }

    function setModAdmin(address modAdmin) external onlyOwner() {
        address previous = s_modAdmin;
        s_modAdmin = modAdmin;
        emit ModAdminSet(previous, modAdmin);
    }

    function setModDivisor(uint256 modDivisor) external onlyModAdmin() {
        uint256 previous = s_modDivisor;
        s_modDivisor = modDivisor;
        emit ModDivisorSet(previous, modDivisor);
    }

    function mod(uint256 n) external {
        s_result = n % s_modDivisor;
    }

    function getOwner() external view returns (address owner) {
        owner = s_owner;
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
        if (msg.sender != s_owner) {
            revert OnlyOwner(s_owner, msg.sender);
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
