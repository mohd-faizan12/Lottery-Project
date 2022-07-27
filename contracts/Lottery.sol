// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
contract Lottery{
    address  public manager;
    address payable[] public participant;
    modifier mCheck{
        require(msg.value>=1 ether,"Require at least one ether");
        _;
    }
    modifier managerOnly{
        require(msg.sender==manager,"You are not authorised");
        _;
    }
    modifier participantsLength{
        require(participant.length>=3,"Participnts should be at least 3");
        _;
    } 
    event eResult(address winner);
    constructor() {
        manager=msg.sender;
    }
  receive() external mCheck payable{
       participant.push(payable(msg.sender));
    }
    function checkBalance() public view managerOnly returns(uint){
        return address(this).balance;
    }
    function Random() public pure returns(uint){
        return uint(keccak256(abi.encodePacked()));
    }
    function selectWinner() managerOnly participantsLength public {
        uint r=Random();
       address payable winner; 
       uint index=r%participant.length;
        winner=participant[index];
        winner.transfer(checkBalance());
        emit eResult(winner);
        participant=new address payable[](0);

    }
}