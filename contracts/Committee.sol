// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Committee {
    address payable  [] public participants;
    address payable  [] public exWinners;
    address payable  [] public futureWinners;
    address payable  [] public missingMembers;
    address [] public areAbsent;
    address public committeeOwner;
    bool public isCommitteeClosed = false;
    bool public nonWinners = true;
    
    event committeeWinner (address winner);
    event newParticipant (address isNew);
    
    modifier onlycommitteeOwnerCalls () {
        require(msg.sender == committeeOwner, "only contract initiator can call this");
        _;
    }
    modifier nonLeaving{
        require(participants.length == futureWinners.length + exWinners.length,"length not matched");
        _;
    }
    modifier committeeClosed {
        require(isCommitteeClosed == false, "game has not been eneded yet, someone is missing from prev team");
        _;
    }
    modifier isOldUser(address _address) {
        bool isOld = false;
        for(uint64 i = 0; i < exWinners.length; i++) {
            if(exWinners[i] == _address){
                isOld = true;
            }
        }
        if(!isOld) {
            for(uint64 i = 0; i < futureWinners.length; i++) {
                if(futureWinners[i] == _address){
                    isOld = true;
                }
            }
        }
        require(isOld == true, "new user alert before committee ends");
        _;
    }
    modifier isNewEnter {
        require(participants.length == futureWinners.length);
        _;
    }
    
    constructor() {
        committeeOwner = msg.sender;
    }
    
    //pseudo random number amoung no. of participants
    function  random() private view returns (uint){
        return uint(keccak256(abi.encode(block.difficulty, block.timestamp, futureWinners)));
    }
    
    function getAllParticipants() public view returns(address payable [] memory) {
        return participants;
    }
    
    function getFutureParticipants () public view returns(address payable [] memory) {
        return futureWinners;   
    }

    function getExParticipants () public view returns(address payable [] memory) {
        return exWinners;   
    }
    
    function getAbsent () public view returns(address  [] memory) {
        return areAbsent;   
    }
    
    function getMissingMembers () public view returns(address payable [] memory) {
        return missingMembers;
    }
    
    function getContractAmount () public view returns(uint){
        return address(this).balance;
        
    }
    
    function newEntries () public payable isNewEnter committeeClosed{
        require(msg.value == 0.1 ether, "0.1 eth is the fixed amount to participate ");
        participants.push(payable(msg.sender));
        futureWinners.push(payable(msg.sender));
        emit newParticipant(msg.sender);
    }
    
    
    function ReEnter() public payable isOldUser(msg.sender)  {
        require(participants.length != 0, "complete previous batch");
        require(msg.value == 0.1 ether, "0.1 eth is the fixed amount to participate ");
        missingMembers.push(payable(msg.sender));
    }
    
    
    function choseWinner()  public onlycommitteeOwnerCalls  nonLeaving{
        uint futureLength = futureWinners.length;
        
        if(isCommitteeClosed == true) {
            uint n = participants.length;
            uint m = missingMembers.length;
          
            for(uint64 i = 0; i < n ; i++) {
                uint64 j;
                for(j = 0; j < m; j++) {
                    if(participants[i] == missingMembers[j]){
                        break;
                    }
                }
                if( j == m) {
                   areAbsent.push(participants[i]);
                }
            }
            
            uint temp = areAbsent.length;
            if(temp != 0) {
                areAbsent = new address [](0);
                require(temp == 0, "someone's missing");
            }
        }

        
        uint winnerIndex = random() % futureLength;  
        
        
        participants[winnerIndex].transfer(address(this).balance);
        isCommitteeClosed = true;
        exWinners.push(participants[winnerIndex]);
        
        // delete futureWinners[winnerIndex];
        futureWinners[winnerIndex] = futureWinners[futureLength - 1];
        futureWinners.pop();
        
        areAbsent = new address [](0);
        missingMembers = new address payable[](0);
        
        
        if(futureWinners.length == 0) {
            isCommitteeClosed = false;
            emit committeeWinner(participants[winnerIndex]);
            participants = new address payable [](0);    
            exWinners = new address payable [](0);    
        }
        if(participants.length != 0){
            emit committeeWinner(participants[winnerIndex]);
        }
    }
    
}
