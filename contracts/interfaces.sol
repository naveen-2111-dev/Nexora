// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

interface INexora {
    function RegisterChannel(uint256 workspaceId, address channel) external;
    function GetChannel(uint256 channelId) external view returns (string memory name, uint256 workspaceId);
    function GetWorkspace(uint256 workspaceId) external view returns (string memory title, address owner);
}
