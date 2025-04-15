// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../core/channel.sol";
import "../interface/interfaces.sol";

contract NEXORAChannelfactory {
    event ChannelCreated(address indexed channelAddress, uint256 workspaceId);
    address public workspace;

    mapping(uint256 => ChannelContract) public channels;

    constructor(address _workspaceContract) {
        workspace = _workspaceContract;
    }

    function CreateChannel(
        uint256 _channelId,
        string memory _channelName,
        uint256 _wrkSpaceId,
        string[] memory _members
    ) public {
        ChannelContract newChannel = new ChannelContract(
            msg.sender,
            _channelId,
            _channelName,
            _wrkSpaceId,
            _members
        );

        channels[_channelId] = newChannel;

        IWorkSpaceContract(workspace).RegisterChannel(_wrkSpaceId, address(newChannel));
        emit ChannelCreated(address(newChannel), _wrkSpaceId);
    }

    function GetChannel(uint256 channelId)
        public
        view
        returns (
            string memory name,
            uint256 id,
            address owner,
            uint256 workspaceId,
            string[] memory channelMembers
        )
    {
        ChannelContract ch = channels[channelId];

        name = ch.channelName();
        id = ch.channelId();
        owner = ch.channelOwner();
        workspaceId = ch.workspaceId();
        channelMembers = ch.getMembers();
    }
}
