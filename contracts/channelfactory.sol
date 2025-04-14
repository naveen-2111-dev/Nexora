// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "./channel.sol";
import "./interfaces.sol";

contract NEXORAChannelfactory {
    event ChannelCreated(address indexed channelAddress, uint256 workspaceId);
    address public workspace;

    constructor (address _workspaceContract){
        workspace = _workspaceContract;
    }

    function CreateEvent(
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
        INexora(workspace).RegisterChannel(_wrkSpaceId, address(newChannel));

        emit ChannelCreated(address(newChannel), _wrkSpaceId);
    }
}
