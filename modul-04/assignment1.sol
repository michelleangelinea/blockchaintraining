// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract DecentralizedVotingSystem {
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    mapping(uint256 => Candidate) public candidates;
    uint256[] public candidateIds;
    mapping(address => bool) public hasVoted;
    uint256 public candidateCount;
    uint256 public winnerId;

    event CandidateAdded(uint256 id, string name);
    event VoteCast(address voter, uint256 candidateId);
    event WinnerDeclared(uint256 winnerId, string winnerName, uint256 voteCount);

    constructor() {
        candidateCount = 0;
    }

    function addCandidate(string memory _name) public {
        candidateCount++;
        candidates[candidateCount] = Candidate(candidateCount, _name, 0);
        candidateIds.push(candidateCount);
        emit CandidateAdded(candidateCount, _name);
    }

    function castVote(uint256 _candidateId) public {
        require(!hasVoted[msg.sender], "You have already voted.");
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate ID.");

        candidates[_candidateId].voteCount++;
        hasVoted[msg.sender] = true;
        emit VoteCast(msg.sender, _candidateId);
    }

    function getTotalVotes(uint256 _candidateId) public view returns (uint256) {
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate ID.");
        return candidates[_candidateId].voteCount;
    }

    function declareWinner() public {
        uint256 highestVoteCount = 0;
        for (uint256 i = 1; i <= candidateCount; i++) {
            if (candidates[i].voteCount > highestVoteCount) {
                highestVoteCount = candidates[i].voteCount;
                winnerId = i;
            }
        }
        emit WinnerDeclared(winnerId, candidates[winnerId].name, highestVoteCount);
    }
}