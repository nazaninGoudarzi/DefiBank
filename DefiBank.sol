// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

interface MyERC20 {
    // When this limit is reached, the smart contract will refuse to create new tokens
    function totalSupply() external view returns (uint);
    // How many tokens a given address has
    function balanceOf(address customer) external view returns (uint);
    // Transfers _value amount of tokens (from totalSupply) to address _to
    // We should check if caller has enough token to spend
    function transfer(address toCustomer, uint amount) external returns (bool);
    // Transfers _value amount of tokens from address _from to address _to
    // Between two users that have tokens
    function transferFrom(address fromCustomer, address toCustomer, uint amount) external returns (bool);
    // Allows _spender to withdraw from your account multiple times, up to the _value amount
    // Verifies that your contract can give a certain amount of tokens to a user
    function approve(address spenderCustomer, uint amount) external returns (bool);
    // Returns the amount which _spender is still allowed to withdraw from _owner
    function allowance(address customer, address spenderCustomer) external view returns (uint);
    event Transfer(address indexed fromCustomer, address indexed toCustomer, uint amount);
    event Approval(address indexed customer, address indexed spenderCustomer, uint amount);
}

contract DefiBank {
    // Declaration
    address Owner;
    address public USDC;
    address public MTToken;

    mapping (uint => customer) customersInfo;
    uint numOfCustomers = 0;
    struct customer {
        address account;
        uint accountBalance;
        uint stakeTime;
    }

    // Initiating the owner of the DefiBank
    constructor() public{
        USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
        MTToken = 0x2B0746E89Bc60bd196dAC88A095c7340e175D077;
        Owner = msg.sender;
        //customersInfo[numOfCustomers].account = Owner;
        //customersInfo[numOfCustomers].accountBalance = MyERC20(USDC).totalSupply();
    }

    // You can use this function to stake tokens
    function stake () external payable {
        // If we already have this customer, this will be true
        bool temp = false;

        //This is for old customers
        for (uint i = 0; i < numOfCustomers; i++) {
            if(customersInfo[i].account == msg.sender) {
                MyERC20(USDC).transferFrom(msg.sender, address(this), msg.value);
                customersInfo[i].accountBalance += msg.value;
                temp = true;
                break;
            }
        }
        // This is for new customers
        if(temp = false) {
            MyERC20(USDC).transferFrom(msg.sender, address(this), msg.value);
            customersInfo[numOfCustomers].account = msg.sender;
            customersInfo[numOfCustomers].accountBalance = msg.value;
            customersInfo[numOfCustomers].stakeTime = block.timestamp;
            numOfCustomers ++;
        }
    }

    // You can use this function to unstake tokens
    function unstake () public {
        // If we already have this customer, this will be true
        bool temp = false;

        for (uint i = 1; i < numOfCustomers; i++) {
            if(customersInfo[i].account == msg.sender) {
                uint totalBalance = customersInfo[i].accountBalance;
                require(totalBalance > 0,'You have already received your tokens!!');
                if(totalBalance > 0) {
                    MyERC20(USDC).transfer(msg.sender, totalBalance);
                    // We will remove the customer
                    customersInfo[i].account = 0x0000000000000000000000000000000000000000;
                    customersInfo[i].accountBalance = 0;
                    temp = true;
                    break;
                }
            }
        }
        if(!temp) {
            require(temp,'You do not ave any token in Defi Bank!');
        }
    }

    // This function is for interest payment
    function interestPayment () public {
        require (msg.sender == Owner,'You do not have permission to access this section.');
        for (uint i = 0; i < numOfCustomers; i++) {
            if(customersInfo[i].accountBalance != 0) {
                uint currentTime = block.timestamp;
                uint difference = (currentTime - (customersInfo[i].stakeTime)) / 60 / 60 / 24;
                if(difference >= 30 days) {
                    customersInfo[i].accountBalance += (5 * customersInfo[i].accountBalance) / 100;
                    MyERC20(MTToken).transfer(customersInfo[i].account, customersInfo[i].accountBalance);
                }
            }
        }
    }
}

