// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10; 

contract voting{
    //struct is to create the sceleton for the contract.
    struct Candidate{
        // struct - framework for storing details of candidate
        uint id;
        string name;
        uint voteCount;
        //struct data type is the struct name i.e Candidate
    }

    //mappping - to interact with struct.
    // mapping(key,value)
    //key can be any value but it shouldn't be another mapping i.e nested mapping . value can be a nested mapping
    //here key is struct datatype
    mapping(uint => Candidate)public candidates;
    //next mapping is to prevent the candidate voting more than once
    mapping(address =>bool)public hasVoted;//to check whether the candidate has voted or not

    //constructor is used to give the details of candidate at the begining itself.constructor runs only when contract is created.
    //getting candidate name inside array
    //store candidate_count as state variable
    uint public candidateCount;//for line 37
    constructor(string[] memory _candidateName){
        //for(initialisation,condition,increment) this is the syntax
        //condition here is (i<string array's lenth
        for(uint i=0; i< _candidateName.length; i++){
            //creating a functoin call (to pass each candidate name as parameter).function name is addCandidate
            addCandidate(_candidateName[i]);
        }
    }
    //memory - string's storage location. solidity dosent know whwere to store string so we use memory
    //private visiblity is used because addCandidate function can be usind only inside this contract. no one else can call or use this function
    //state change function
    function addCandidate(string memory _name)private{
        candidateCount++;
        //whenever we add candidate its count increases
        //struct is accessed inside mapping . inorder to use the struct below line is used - give key to get value
        //key -uint type,value -struct
        //mapping visiblity name[mapping uint type_key] = struct_name(parameter_struct_properties)
        candidates[candidateCount] = Candidate({
            id:candidateCount,
            name:_name, //in line 36 we get candidate name by variable _name
            voteCount:0 //initially voting count is 0

        });
    }

    //function for voting 
    function vote(uint _candidateId)public {
        //condition 1.user candidateId > 0, 2.candidateId < candidateCount
        //error handling method-require [test variable value. if test is false then the transaction gets revorted]
        //when revorted then the gass used returns back to the user.but in assert methon it will not give back the spent gas when revorted.
        //assert(condition) -this is the syntax for assert. condition mustalways be true.eg1: assert(a > b) eg2: assert(candidateId=!0).when c
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid Candidate Id" ); //error message "Invalid Candidate Id"
        require(! hasVoted[msg.sender],"Already Voted");//line20. 
        //message.sender- denotes the address of who is currently interacting with function 
        //! voted - stores true in mapping by using not operator. even after using not operator if we false then display error message "Already Voted"
        //candidate[key]=value i.e struct as value for mapping of candidate

        //voteCount(line10) inside struct(line 6), struct inside mapping of candidates(line 18)
        candidates[_candidateId].voteCount++;    //line18
        //change database(hasVoted) that the candidate voted 
        hasVoted[msg.sender] = true; //address of who is voting
    }//vote function in deploy is in ORANGE colour because it changes state of blockchain(eg: state of count changes from 0 to 1).

    function getVoteCount(uint _candidateId)public view returns(uint){
        //(read state[return vote count] - view ), (not change state , not read but return value -pure),(state change- give nothing)

        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid Candidate Id");
        return  candidates[_candidateId].voteCount; //returns struct voteCount
    }
}