// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract ChannelContract {
    address public channelOwner;
    uint256 public channelId;
    uint256 public workspaceId;
    string public channelName;
    string[] public members;
    mapping(string => bool) public isMember;

    constructor(
        address _owner,
        uint256 _channelId,
        string memory _channelName,
        uint256 _workspaceId,
        string[] memory _members
    ) {
        channelOwner = _owner;
        channelId = _channelId;
        channelName = _channelName;
        workspaceId = _workspaceId;

        for (uint256 i = 0; i < _members.length; i++) {
            members.push(_members[i]);
            isMember[_members[i]] = true;
        }
    }

    function addMember(string memory _member) external {
        require(!isMember[_member], "Already a member");

        members.push(_member);
        isMember[_member] = true;
    }

    function removeMember(string memory _member) external {
        require(isMember[_member], "Not a member");

        isMember[_member] = false;
    }

    function getMembers() external view returns (string[] memory) {
        return members;
    }
}
