pragma solidity >= 0.5.8;

contract Election {

    struct Candidate {
        uint id;
        string name;
        string partyName;
        string partySymbol;
        uint voteCount;
    }

    struct Voter {
        uint id;
        uint age;
        string name;
        bool voted;
    }

    mapping (uint => Candidate) public candidates;
    mapping (uint => Voter) public voters;
    address public ownerAddress;
    uint public candidatesCount;
    uint public votersCount;
    bool public votingStarted;

    constructor() public payable {
        ownerAddress = msg.sender;
        candidatesCount = 0;
        votersCount = 0;
        votingStarted = false;
    }

    modifier onlyOwner() {
        require(msg.sender == ownerAddress, "Only owner can add a candidate/voter.");
        _;
    }

    function votingAction(bool _start) public onlyOwner {
        votingStarted = _start;
    }

    function addVoter (string memory _name, uint _age) public onlyOwner payable {
        if (_age < 18) {
            revert("Age should be atleast 18");
        } else {
            votersCount++;
            voters[votersCount] = Voter(votersCount, _age, _name, false);
        }
    }

    function addCandidate (string memory _name, string memory _partyName, string memory _partySymbol) public onlyOwner payable {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, _partyName, _partySymbol, 0);
    }

    function voteCandidate (uint _voterId, uint _candidateId) public payable {
        if (_voterId > votersCount || _candidateId > candidatesCount) {
            revert("Invalid voting operation");
        } else if (!votingStarted) {
            revert("You can't vote now.");
        } else {
            if (voters[_voterId].voted) {
                revert("Already voted!");
            } else {
                candidates[_candidateId].voteCount++;
                voters[_voterId].voted = true;
            }
        }
    }

}