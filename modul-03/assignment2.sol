// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract MembershipSystem {
    enum MembershipType { Basic, Premium, VIP }

    struct Member {
        uint256 id;
        string name;
        uint256 balance;
        MembershipType membershipType;
    }

    mapping(address => Member) private members;
    uint256 private memberIdCounter = 1;

    function addMember(address newMember, string memory name, uint256 balance, MembershipType membershipType, string memory additionalInfo) external {
        members[newMember] = Member({
            id: memberIdCounter,
            name: name,
            balance: balance,
            membershipType: membershipType
        });
        memberIdCounter++;
    }

    function removeMember(address existingMember) external {
        delete members[existingMember];
    }

    function isMember(address addr) external view returns (bool) {
        return members[addr].id != 0;
    }

    function setName(address memberAddress, string memory newName) external {
        members[memberAddress].name = newName;
    }

    function setBalance(address memberAddress, uint256 newBalance) external {
        members[memberAddress].balance = newBalance;
    }

    function setMembershipType(address memberAddress, MembershipType newType) external {
        members[memberAddress].membershipType = newType;
    }

    // Function to get member details
    function getMemberDetails(address memberAddress) external view returns (Member memory) {
        return members[memberAddress];
    }
}
