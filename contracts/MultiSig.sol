pragma solidity ^0.5.2;

contract MultiSig{

    address[]public approvers;
    uint public quorum;

    struct Transfer{
        uint id;
        uint amount;
        address payable to;
        uint approvals;
        bool sent;

    }

    mapping(uint=>Transfer)public transfers;
    uint nextId;
    mapping(address=>mapping(uint=>bool))approvals;

   
    constructor(address[] memory _approvers, uint _quorum)payable public{
        approvers= _approvers;
        quorum= _quorum;

    }

    function createTransfer(uint amount, address payable to)external{
       transfers[nextId]= Transfer(nextId,amount,to,0, false);
       nextId++;

    }

    function sendTransfer(uint id)external{
        require(transfers[id].sent=! false,'Transfer has already been sent');
        if(transfers[id].approvals >= quorum){
            transfers[id].sent= true;
            address payable to= transfers[id].to;
            uint amount= transfers[id].amount;
            to.transfer(amount);
            return;

        }

        if(approvals[msg.sender][id] == false){
        transfers[id].approvals++;

        }

    }

}