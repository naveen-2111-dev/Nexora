// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract WorkspaceBase {
    address public spaceOwner;
    uint256 public workspaceId;
    string public photo;
    string public spaceName;
    string[] public colleagues;
    address[] public channels;

    mapping(string => bool) public isColleague;

    constructor(
        address _owner,
        uint256 _workspaceId,
        string memory _photo,
        string memory _spaceName,
        string[] memory _mates,
        address[] memory _channels
    ) {
        spaceOwner = _owner;
        workspaceId = _workspaceId;
        photo = _photo;
        spaceName = _spaceName;
        colleagues = _mates;
        channels = _channels;

        for (uint256 i = 0; i < _mates.length; i++) {
            isColleague[_mates[i]] = true;
        }
    }

    struct Task {
        uint256 taskId;
        string title;
        string description;
        address assignedTo;
        bool isCompleted;
        uint256 dueDate;
    }

    mapping(uint256 => Task) public tasks;
    uint256 public taskCount;

    function createTask(
        string memory _title,
        string memory _description,
        address _assignedTo,
        uint256 _dueDate
    ) public returns (uint256) {
        taskCount++;
        tasks[taskCount] = Task({
            taskId: taskCount,
            title: _title,
            description: _description,
            assignedTo: _assignedTo,
            isCompleted: false,
            dueDate: _dueDate
        });
        return taskCount;
    }

    function getTask(uint256 _taskId) public view returns (Task memory) {
        return tasks[_taskId];
    }

    function markTaskCompleted(uint256 _taskId) public {
        Task storage task = tasks[_taskId];
        task.isCompleted = true;
    }

    function getColleagues() public view returns (string[] memory) {
        return colleagues;
    }

    function addColleague(string memory newMate) public {
        require(!isColleague[newMate], "Already a colleague");
        colleagues.push(newMate);
        isColleague[newMate] = true;
    }

    function registerChannel(address _channel) public {
        for (uint256 i = 0; i < channels.length; i++) {
            require(channels[i] != _channel, "Channel already registered");
        }
        channels.push(_channel);
    }

    function getChannels() public view returns (address[] memory) {
        return channels;
    }
}
