pragma solidity ^0.4.0;
contract Voter {
    struct OptionPos {
        uint pos;
        bool exists;
    }

    uint[] public votes;
    mapping(address => bool) hasVoted;
    mapping(string => OptionPos) posOfOption;
    string[] public options;
    bool votingStarted;

    function addOption(string option) public {
        require(!votingStarted);
        options.push(option);
    }

    function startVoting() public {
        require(!votingStarted);
        votes.length = options.length;

        for(uint i=0; i < options.length; i++) {
            OptionPos memory option = OptionPos(i, true);
            posOfOption[options[i]] = option;
        }
        votingStarted = true;
    }

    function vote(string option) public {

        require(keccak256(abi.encodePacked(0)) <= keccak256(abi.encodePacked(option)) && keccak256(abi.encodePacked(option)) < keccak256(abi.encodePacked(options.length)));
        require(!hasVoted[msg.sender]);

        hasVoted[msg.sender] =true;

        var(voterOption, hasBadBytes) = stringToUint(option);
        if(!hasBadBytes) {
           votes[voterOption] = votes[voterOption] +1;
        } else {
            //
        }
       
    }

    function stringToUint(string s) public pure returns (uint, bool) {
    bool hasError = false;
    bytes memory b = bytes(s);
    uint result = 0;
    uint oldResult = 0;
    for (uint i = 0; i < b.length; i++) { // c = b[i] was not needed
        if (b[i] >= 48 && b[i] <= 57) {
            // store old value so we can check for overflows
            oldResult = result;
            result = result * 10 + (uint(b[i]) - 48); // bytes and int are not compatible with the operator -.
            // prevent overflows
            if(oldResult > result ) {
                // we can only get here if the result overflowed and is smaller than last stored value
                hasError = true;
            }
        } else {
            hasError = true;
        }
    }
    return (result, hasError); 
}

}