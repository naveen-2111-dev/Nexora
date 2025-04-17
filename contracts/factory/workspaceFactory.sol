// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "../core/workspace.sol";

contract WorkspaceManager {
    uint256 public workspaceCount;
    uint256 public memberCount;
    uint256 public taskCount;

    mapping(uint256 => address) public workspaces;

    event CreatedNewWorkspace(uint256 spaceId, string message);
    event MemberAdded(uint256 spaceId, string newMember);
    event TaskCreated(uint256 spaceId, uint256 taskId, string message);

    function createWorkspace(
        string memory _photo,
        string memory _spaceName,
        string[] memory _mates,
        address[] memory _channels
    ) public returns (uint256, address) {
        workspaceCount++;

        WorkspaceBase newWorkspace = new WorkspaceBase(
            msg.sender,
            workspaceCount,
            _photo,
            _spaceName,
            _mates,
            _channels
        );

        workspaces[workspaceCount] = address(newWorkspace);

        emit CreatedNewWorkspace(
            workspaceCount,
            "Workspace created successfully"
        );

        return (workspaceCount, address(newWorkspace));
    }

    function addWorkspaceMember(
        uint256 _workspaceId,
        string memory newMate
    ) external {
        address workspaceAddress = workspaces[_workspaceId];
        WorkspaceBase workspace = WorkspaceBase(workspaceAddress);

        workspace.addColleague(newMate);

        memberCount++;
        emit MemberAdded(_workspaceId, newMate);
    }

    function createTask(
        uint256 _workspaceId,
        string memory _title,
        string memory _description,
        address _assignedTo,
        uint256 _dueDate
    ) external returns (uint256) {
        address workspaceAddress = workspaces[_workspaceId];
        WorkspaceBase workspace = WorkspaceBase(workspaceAddress);

        uint256 taskId = workspace.createTask(
            _title,
            _description,
            _assignedTo,
            _dueDate
        );
        taskCount++;

        emit TaskCreated(_workspaceId, taskId, "Task created successfully");

        return taskId;
    }

    function getWorkspaceDetails(
        uint256 _workspaceId
    )
        external
        view
        returns (
            address,
            uint256,
            string memory,
            string memory,
            string[] memory,
            address[] memory
        )
    {
        address workspaceAddress = workspaces[_workspaceId];
        WorkspaceBase workspace = WorkspaceBase(workspaceAddress);

        return (
            workspace.spaceOwner(),
            workspace.workspaceId(),
            workspace.photo(),
            workspace.spaceName(),
            workspace.getColleagues(),
            workspace.getChannels()
        );
    }

    function getTaskDetails(
        uint256 _workspaceId,
        uint256 _taskId
    ) external view returns (WorkspaceBase.Task memory) {
        address workspaceAddress = workspaces[_workspaceId];
        WorkspaceBase workspace = WorkspaceBase(workspaceAddress);

        return workspace.getTask(_taskId);
    }

    function getChannel(
        uint256 _workspaceId
    ) external view returns (address[] memory) {
        address workspaceAddress = workspaces[_workspaceId];
        WorkspaceBase workspace = WorkspaceBase(workspaceAddress);
        return workspace.getChannels();
    }

    function RegisterChannel(
        uint256 _workspaceId,
        address _channelAddress
    ) external {
        address workspaceAddress = workspaces[_workspaceId];
        WorkspaceBase workspace = WorkspaceBase(workspaceAddress);
        workspace.registerChannel(_channelAddress);
    }
}
