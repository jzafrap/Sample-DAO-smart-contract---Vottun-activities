// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


pragma solidity ^0.8.0;

contract DAO {
    // Token and Treasury
    IERC20 public token;
    address public treasury;

    // Proposal Struct
    struct Proposal {
        uint256 id;
        string description;
        uint256 voteStart;
        uint256 voteEnd;
        uint256 votesFor;
        uint256 votesAgainst;
        bool executed;
    }

    // Mapping of Proposal IDs to Proposals
    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

    // Events
    event ProposalCreated(uint256 id, string description, uint256 voteStart, uint256 voteEnd);
    event Voted(address voter, uint256 proposalId, bool support);
    event ProposalExecuted(uint256 proposalId);

    // Constructor
    constructor(address _tokenAddress, address _treasuryAddress) {
        token = IERC20(_tokenAddress);
        treasury = _treasuryAddress;
    }

    // Functions
    function createProposal(string memory _description, uint256 _votePeriod) public {
        proposalCount++;
        uint256 id = proposalCount;
        proposals[id] = Proposal(id, _description, block.timestamp, block.timestamp + _votePeriod, 0, 0, false);
        emit ProposalCreated(id, _description, block.timestamp, block.timestamp + _votePeriod);
    }

    function vote(uint256 _proposalId, bool _support) public {
        require(block.timestamp >= proposals[_proposalId].voteStart && block.timestamp <= proposals[_proposalId].voteEnd, "Voting period is not active");
        require(token.balanceOf(msg.sender) > 0, "You must hold tokens to vote");

        if (_support) {
            proposals[_proposalId].votesFor++;
        } else {
            proposals[_proposalId].votesAgainst++;
        }

        emit Voted(msg.sender, _proposalId, _support);
    }

    function executeProposal(uint256 _proposalId) public {
        require(block.timestamp > proposals[_proposalId].voteEnd, "Voting period has not ended");
        require(proposals[_proposalId].votesFor > proposals[_proposalId].votesAgainst, "Proposal failed");
        require(!proposals[_proposalId].executed, "Proposal already executed");

        // Execute the proposal logic here (e.g., transfer funds, deploy contracts)
        // ...

        proposals[_proposalId].executed = true;
        emit ProposalExecuted(_proposalId);
    }
}