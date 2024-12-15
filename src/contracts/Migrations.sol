// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Migrations {
    address public owner = msg.sender;
    uint public last_completed_migration;

    // Event declaration for tracking migration updates
    event MigrationCompleted(uint completed);
    event ContractUpgraded(address newAddress);

    modifier restricted() {
        require(msg.sender == owner, "This function is restricted to the contract's owner");
        _;
    }

    /**
     * @dev Set the last completed migration step.
     * @param completed The migration step number to be marked as completed.
     */
    function setCompleted(uint completed) public restricted {
        last_completed_migration = completed;
        emit MigrationCompleted(completed); // Emit the event when a migration is completed
    }

    /**
     * @dev Upgrade the contract by setting the last completed migration in the new address.
     * @param new_address The address of the new Migrations contract.
     */
    function upgrade(address new_address) public restricted {
        Migrations(new_address).setCompleted(last_completed_migration);
        emit ContractUpgraded(new_address); // Emit the event when upgrading the contract
    }
}
