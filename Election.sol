pragma solidity ^0.5.6;

contract Election {
    address public chairperson;

    struct Voter {
        uint weight;
        bool voted;
    }

    struct Issue {
        bytes32 name;
        uint voteCount;
    }

    Issue[] public proposal;

    mapping (address => Voter) public voters;
    uint votersCount;

    modifier onlyChairperson() {
        require(msg.sender == chairperson, "Only chairperson can call this function");
        _;
    }

    modifier condition(bool _condition) {
        require(_condition, "Condition not met!");
        _;
    }

    constructor(bytes32[] memory proposalList, address[] memory votersList) public {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        for (uint i = 0; i < proposalList.length; i++) {
            proposal.push(Issue({
                name: proposalList[i],
                voteCount: 0
            }));
        }

        for (uint i = 0; i < votersList.length; i++) {
            voters[votersList[i]] = Voter(1, false);
        }
    }

    function giveVotingRight(address _address) public onlyChairperson {
        votersCount ++;
        voters[_address] = Voter(1, false);
    }

    function Vote(uint _proposal) public condition(!voters[msg.sender].voted) {
        require(voters[msg.sender].weight != 0, "You don't have a right to vote!");
        proposal[_proposal].voteCount += voters[msg.sender].weight;
        voters[msg.sender].voted = true;
    }

    function winnerIndex() private view onlyChairperson returns (uint winnerIndex_) {
        uint winningVoteCount;

        for(uint p; p < proposal.length; p++) {
            if(proposal[p].voteCount > winningVoteCount) {
                winningVoteCount = proposal[p].voteCount;
                winnerIndex_ = p;
            }
        }
    }

    function winner() public view onlyChairperson returns (bytes32 winner_) {
        winner_ = proposal[winnerIndex()].name;
    } 
}