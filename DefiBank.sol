// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import 'MyToken.sol';

contract DefiBank {
    // Declaration
    address Owner;
    address public MTToken;
    MyERC20 public token;

    mapping (uint => customer) customersInfo;
    // the price, in wei, per token
    uint price = 1; 
    uint numOfCustomers = 0;
    struct customer {
        address account;
        uint accountBalance;
        uint stakeTime;
    }

    // Initiating the owner of the DefiBank
    constructor() {
        //MTToken = 0x2B0746E89Bc60bd196dAC88A095c7340e175D077;
        token = new MyERC20(20000000000000000000);
        Owner = msg.sender;
    }

    // You can use this function to stake tokens
    function stake () external payable {
        require(msg.value > 0, 'You need to send some ether');
        // If we already have this customer, this will be true
        bool stakeTemp = false;
        uint bankBalance = token.balanceOf(address(this));
        require(msg.value <= bankBalance, 'Not enough tokens in the reserve');

        //This is for old customers
        for (uint i = 0; i < numOfCustomers; i++) {
            if(customersInfo[i].account == msg.sender) {
                customersInfo[i].accountBalance += msg.value;
                token.transfer(msg.sender, msg.value);
                token.approve(msg.sender,msg.value);
                stakeTemp = true;
                break;
            }
        }
        // This is for new customers
        if(stakeTemp == false) {
            customersInfo[numOfCustomers].account = msg.sender;
            customersInfo[numOfCustomers].accountBalance = msg.value;
            customersInfo[numOfCustomers].stakeTime = block.timestamp;
            token.transfer(msg.sender, msg.value);
            token.approve(msg.sender,msg.value);
            numOfCustomers ++;
        }
    }

    // You can use this function to unstake tokens
    function unstake (uint tokenAmount) public {
        require(tokenAmount > 0, 'You need to sell at least some tokens');
        //uint allowance = token.allowance(msg.sender, address(this));
        //require(allowance >= tokenAmount, 'Check the token allowance');
        // If we already have this customer, this will be true
        bool unstakeTemp = false;

        for (uint i = 0; i < numOfCustomers; i++) {
            if(customersInfo[i].account == msg.sender) {
                uint totalBalance = customersInfo[i].accountBalance;
                require(totalBalance > 0,'You have already received your tokens!!');
                MyERC20(MTToken).transferFrom(msg.sender, address(this), tokenAmount);
                address payable customerAddress = payable(msg.sender);
                customerAddress.transfer(tokenAmount);
                // We will remove the customer
                customersInfo[i].account = 0x0000000000000000000000000000000000000000;
                customersInfo[i].accountBalance = 0;
                unstakeTemp = true;
                break;
            }
        }
        if(unstakeTemp == false) {
            require(unstakeTemp == true,'You do not have any token in Defi Bank!');
        }
    }

    // This function is for interest payment
    function interestPayment () public {
        require (msg.sender == Owner,'You do not have permission to access this section.');
        for (uint i = 0; i < numOfCustomers; i++) {
            if(customersInfo[i].accountBalance != 0) {
                uint currentTime = block.timestamp;
                //uint difference = (currentTime - (customersInfo[i].stakeTime)) / 60 / 60 / 24;
                uint difference = (currentTime - (customersInfo[i].stakeTime));
                if(difference >= 10 seconds) {
                    customersInfo[i].accountBalance += (5 * customersInfo[i].accountBalance) / 100;
                    token.transfer(customersInfo[i].account, customersInfo[i].accountBalance);
                }
            }
        }
    }

    //this function enables the contract to receive funds
    receive () external payable {
    }
}

