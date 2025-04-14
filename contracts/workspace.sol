// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract WorkSpaceContract {
    struct Workspace {
        address spaceOwner;
        uint256 workspaceId;
        string photo;
        string spaceName;
        string[] colleagues;
        address[] channels;
        mapping(string => bool) isColleague;
        mapping(uint256 => Task) tasks;
    }

    struct Task {
        uint256 taskId;
        string title;
        string description;
        address assignedTo;
        bool isCompleted;
        uint256 dueDate;
    }

    mapping(uint256 => Workspace) private workspaceStorage;
    uint256 public WorkspaceCount = 0;
    uint256 public memberCount = 0;
    uint256 public TaskCount = 0;

    event CreatedNewWorkspace(uint256 spaceId, string message);
    event MemberAdded(uint256 spaceId, string message, string newMember);
    event TaskCreated(uint256 spaceId, uint256 taskId, string message);

    struct WorkspaceData {
        address spaceOwner;
        uint256 workspaceId;
        string photo;
        string spaceName;
        string[] colleagues;
        address[] channels;
    }

    function GetWorkspace(
        uint256 workspaceId
    ) public view returns (WorkspaceData memory) {
        Workspace storage ws = workspaceStorage[workspaceId];
        return
            WorkspaceData(
                ws.spaceOwner,
                ws.workspaceId,
                ws.photo,
                ws.spaceName,
                ws.colleagues,
                ws.channels
            );
    }

    function CreateWorkspace(
        string memory _photo,
        string memory _spaceName,
        string[] memory _mates,
        address[] memory _channels
    ) public returns (uint256) {
        WorkspaceCount++;

        Workspace storage ws = workspaceStorage[WorkspaceCount];
        ws.spaceOwner = msg.sender;
        ws.workspaceId = WorkspaceCount;
        ws.photo = _photo;
        ws.spaceName = _spaceName;
        ws.colleagues = _mates;
        ws.channels = _channels;

        for (uint256 i = 0; i < _mates.length; i++) {
            ws.isColleague[_mates[i]] = true;
        }

        emit CreatedNewWorkspace(WorkspaceCount, "success");

        return WorkspaceCount;
    }

    function AddWorkspaceMember(
        uint256 _spaceId,
        string memory newMate
    ) external {
        Workspace storage ws = workspaceStorage[_spaceId];

        require(!ws.isColleague[newMate], "Already a mate");
        ws.colleagues.push(newMate);
        ws.isColleague[newMate] = true;

        memberCount++;
        emit MemberAdded(_spaceId, "User added successfully", newMate);
    }

    function GetColleagues(
        uint256 _spaceId
    ) public view returns (string[] memory) {
        return workspaceStorage[_spaceId].colleagues;
    }

    function CreateTask(
        uint256 _workspaceId,
        string memory _title,
        string memory _description,
        address _assignedTo,
        uint256 _dueDate
    ) external returns (uint256) {
        Workspace storage ws = workspaceStorage[_workspaceId];

        TaskCount++;

        Task storage newTask = ws.tasks[TaskCount];
        newTask.taskId = TaskCount;
        newTask.title = _title;
        newTask.description = _description;
        newTask.assignedTo = _assignedTo;
        newTask.isCompleted = false;
        newTask.dueDate = _dueDate;

        emit TaskCreated(_workspaceId, TaskCount, "Task created successfully");

        return TaskCount;
    }

    function GetTask(
        uint256 _workspaceId,
        uint256 _taskId
    ) public view returns (Task memory) {
        return workspaceStorage[_workspaceId].tasks[_taskId];
    }

    function GetChannels(
        uint256 _workspaceId
    ) public view returns (address[] memory) {
        return workspaceStorage[_workspaceId].channels;
    }

    function RegisterChannel(uint256 workspaceId, address _channel) external {
        Workspace storage ws = workspaceStorage[workspaceId];

        for (uint256 i = 0; i < ws.channels.length; i++) {
            require(ws.channels[i] != _channel, "Channel already registered");
        }

        ws.channels.push(_channel);
    }
}
