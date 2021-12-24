// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

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
    address owner;
    mapping (uint => customer) customersInfo;
    uint numOfCustomers = 0;
    struct customer {
        address account;
        uint accountBalance;
    }

    // Initiating the owner of the DefiBank
    constructor() {
        owner = msg.sender;
        customersInfo[numOfCustomers].account = owner;
        customersInfo[numOfCustomers].accountBalance = MyERC20(owner).balanceOf(owner);
    }

    // You can use this function to stake tokens
    function stake () external payable {
        for (uint i = 0; i < numOfCustomers; i++) {
            if()
        }
        MyERC20(owner).transferFrom(msg.sender,address(this),msg.value);
        customersInfo[numOfCustomers].accountBalance += msg.value;
    }

    // You can use this function to unstake tokens
    function unstake () public {
        for (uint i = 0; i < numOfCustomers; i++) {}
    }
}

