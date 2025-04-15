// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

interface IChannelContract {
    function channelOwner() external view returns (address);
    function channelId() external view returns (uint256);
    function workspaceId() external view returns (uint256);
    function channelName() external view returns (string memory);
    function getMembers() external view returns (string[] memory);
    function addMember(string memory _member) external;
    function removeMember(string memory _member) external;
}

interface INEXORAChannelfactory {
    function CreateChannel(
        uint256 _channelId,
        string memory _channelName,
        uint256 _wrkSpaceId,
        string[] memory _members
    ) external;

    function GetChannel(uint256 channelId)
        external
        view
        returns (
            string memory name,
            uint256 id,
            address owner,
            uint256 workspaceId,
            string[] memory channelMembers
        );
}

interface IWorkSpaceContract {
    struct Task {
        uint256 taskId;
        string title;
        string description;
        address assignedTo;
        bool isCompleted;
        uint256 dueDate;
    }

    struct WorkspaceData {
        address spaceOwner;
        uint256 workspaceId;
        string photo;
        string spaceName;
        string[] colleagues;
        address[] channels;
    }

    function CreateWorkspace(
        string memory _photo,
        string memory _spaceName,
        string[] memory _mates,
        address[] memory _channels
    ) external returns (uint256);

    function AddWorkspaceMember(uint256 _spaceId, string memory newMate) external;

    function GetColleagues(uint256 _spaceId) external view returns (string[] memory);

    function CreateTask(
        uint256 _workspaceId,
        string memory _title,
        string memory _description,
        address _assignedTo,
        uint256 _dueDate
    ) external returns (uint256);

    function GetTask(uint256 _workspaceId, uint256 _taskId) external view returns (Task memory);

    function GetChannels(uint256 _workspaceId) external view returns (address[] memory);

    function RegisterChannel(uint256 workspaceId, address _channel) external;

    function GetWorkspace(uint256 workspaceId) external view returns (WorkspaceData memory);
}
