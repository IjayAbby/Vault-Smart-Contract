// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.21;

contract Vault {

    uint id;
    address public beneficiary;

    struct Granted{
        uint256 amount;
        uint256 claimTime;
    }


    mapping(address =>  mapping(uint256 => Granted)) beneficiaryGrant;


    function giveGrant (address _beneficiary, uint256 _claimTime) public payable {

       uint256 _id = id + 1;

        require(msg.sender != address(0), "Zero address");

        beneficiaryGrant[_beneficiary][_id].claimTime = _claimTime;

        payable(address (this)).transfer(msg.value);
        
        beneficiaryGrant[_beneficiary][_id].amount = msg.value;

        id = _id;

    }

    function claim(uint _id) public {

        require(msg.sender != address(0), "Zero Address");

        require(msg.sender == beneficiary, "Only beneficiary can claim for grant");

        require(block.timestamp >= beneficiaryGrant[msg.sender][_id].claimTime, "Maturity time not yet reached to claim grant");

        uint _amountToClaim = beneficiaryGrant[msg.sender][_id].amount;


        beneficiaryGrant[msg.sender][_id].amount = 0;

        payable (msg.sender).transfer(_amountToClaim);
    }

    

    receive() external payable {}

    fallback() external payable {}

    
}