// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

contract Lottery {
    address public manager;
    address payable[] public participants;

    constructor() {
        manager=msg.sender; // Global variabe
    }

    receive() external payable {
        require(msg.value == 0.001 ether, "Participation fees is 1 ETH");
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint) {
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() public view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, participants.length)));
    }

    function showWinner() public {
        require(msg.sender == manager);
        require(participants.length >= 3);
        uint r = random();
        address payable winner;
        uint index = r % participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0);
    }
}
