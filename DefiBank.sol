// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import 'MyToken.sol';

contract DefiBank {
    // Declaration
    address Owner;
    MyERC20 private token;

    mapping (uint => customer) customersInfo;
    // the price, in wei, per token
    uint price = 1; 
    uint numOfCustomers;
    struct customer {
        address account;
        uint accountBalance;
        uint stakeTime;
    }

    // Initiating the owner of the DefiBank
    constructor(uint val) {
        token = new MyERC20(val);
        Owner = msg.sender;
        numOfCustomers = 0;
    }

    // You can use this function to stake tokens
    function stake () external payable {
        require(msg.value > 0, 'You need to send some ether');
        // If we already have this customer, this will be true
        bool stakeTemp = false;

        //This is for old customers
        for (uint i = 0; i < numOfCustomers; i++) {
            if(customersInfo[i].account == msg.sender) {
                customersInfo[i].accountBalance += msg.value;
                stakeTemp = true;
                break;
            }
        }
        // This is for new customers
        if(stakeTemp == false) {
            customersInfo[numOfCustomers].account = msg.sender;
            customersInfo[numOfCustomers].accountBalance = msg.value;
            customersInfo[numOfCustomers].stakeTime = block.timestamp;
            token.approve2(msg.sender,address(this),msg.value);
            numOfCustomers ++;
        }
    }

    // You can use this function to unstake tokens
    function unstake () public {
        // If we already have this customer, this will be true
        bool unstakeTemp = false;

        for (uint i = 0; i < numOfCustomers; i++) {
            if(customersInfo[i].account == msg.sender) {
                uint totalBalance = customersInfo[i].accountBalance;
                require(totalBalance > 0,'You have already received your tokens!!');
                token.transfer(msg.sender, totalBalance);
                // We will remove the customer
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
            // By this, we will pay interest to active customers
            if(customersInfo[i].accountBalance != 0) {
                uint currentTime = block.timestamp;
                //uint difference = (currentTime - (customersInfo[i].stakeTime)) / 60 / 60 / 24;
                uint difference = (currentTime - (customersInfo[i].stakeTime));
                if(difference >= 10 seconds) {
                    uint tempBalance = ((5 * customersInfo[i].accountBalance) / 100);
                    customersInfo[i].accountBalance += tempBalance;
                    token.transfer(customersInfo[i].account, tempBalance);
                }
            }
        }
    }

    //this function enables the contract to receive funds
    receive () external payable {
    }
}

