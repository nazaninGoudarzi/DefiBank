// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

interface ERC20 {
    // When this limit is reached, the smart contract will refuse to create new tokens
    function totalSupply() external view returns (uint _totalSupply);
    // How many tokens a given address has
    function balanceOf(address _owner) external view returns (uint balance);
    // Transfers _value amount of tokens (from totalSupply) to address _to
    // We should check if caller has enough token to spend
    function transfer(address _to, uint _value) external returns (bool success);
    // Transfers _value amount of tokens from address _from to address _to
    // Between two users that have tokens
    function transferFrom(address _from, address _to, uint _value) external returns (bool success);
    // Allows _spender to withdraw from your account multiple times, up to the _value amount
    // Verifies that your contract can give a certain amount of tokens to a user
    function approve(address _spender, uint _value) external returns (bool success);
    // Returns the amount which _spender is still allowed to withdraw from _owner
    function allowance(address _owner, address _spender) external view returns (uint remaining);
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}


// My codes
contract MyERC20 is ERC20 {
    // Basics
    string public constant name = "Mtoken";
    string public constant symbol = "MT";

    // Defining totalSupply
    // 20'000'000'000'000'000'000
    uint private constant TotalSupply = 20000000000000000000;

    // This will keep the amount of tokens that our users have
    mapping (address => uint) private usersBalance;

    // This will keep users allowance to spend tokens
    mapping (address => mapping (address => uint)) private usersAllowance;

    // Declaration
    address owner;
    uint allowed;

    // Initiating the owner of the token
    constructor() {
        owner = msg.sender;
        usersBalance[owner] = TotalSupply;
    }

    // When this limit is reached, the smart contract will refuse to create new tokens
    function totalSupply() public pure override returns (uint _totalSupply) {
        return _totalSupply = TotalSupply;
    }

    // How many tokens a given address has
    function balanceOf(address _owner) public view override returns (uint balance) {
        return balance = usersBalance[_owner];
    }

    // Transfers _value amount of tokens to address _to
    // We should check if caller has enough token to spend
    function transfer(address _to, uint _value) public override returns (bool success) {
        require(usersBalance[msg.sender] >= _value,'You do not have enough token to spend and transfer');
        if(usersBalance[msg.sender] >= _value) {
            usersBalance[msg.sender] -= _value;
            usersBalance[_to] += _value;
            emit Transfer(msg.sender, _to, _value);
            success = true;
            return success;
        }
        else {
            success = false;
            return success;
        }
    }

    // Transfers _value amount of tokens from address _from to address _to
    // Between two users that have tokens
    function transferFrom(address _from, address _to, uint _value) public override returns (bool success) {
        allowed = usersAllowance[_from][msg.sender];
        require(usersBalance[_from] >= _value,'This account does not have enough token to spend and transfer');
        require(allowed >= _value,'This account did not allow you to transfer this amount of tokens');
        if(usersBalance[_from] >= _value && allowed>= _value) {
            usersBalance[_from] -= _value;
            usersBalance[_to] += _value;
            usersAllowance[_from][msg.sender] -= _value;
            emit Transfer(_from, _to, _value);
            success = true;
            return success;
        }
        else {
            success = false;
            return success;
        }
    }

    // Allows _spender to withdraw from your account multiple times, up to the _value amount
    // Verifies that your contract can give a certain amount of tokens to a user
    function approve(address _spender, uint _value) public override returns (bool success) {
        usersAllowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        success = true;
        return success;
    }

    // Returns the amount which _spender is still allowed to withdraw from _owner
    function allowance(address _owner, address _spender) public view override returns (uint remaining) {
        return usersAllowance[_owner][_spender];
    }

}
