//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "./ZetToken.sol";

contract ZetTokenFund {
    ZetToken public Token;
    uint public userCount;

    constructor(address tokenAddress) {
        Token = ZetToken(tokenAddress);
    }

    struct userInfo {
        address userAddress;
        uint256 startAt;
        bool funded;
        uint256 userAmount;
        uint256 budged;
    }
    function investMoney() public payable {
        // require(msg.value > 0);
        Token.mint(msg.sender, msg.value);    
        userBalance[msg.sender] += Token.balanceOf(msg.sender);
    }

    mapping(address => userInfo) public registered;
    mapping(address => uint256) public userBalance;

    function startFund(uint256 _amount) public payable {
        require(_amount > 0, "Amount can not be equal to zero.");
        userInfo memory user;

       if(!user.funded){
            userBalance[msg.sender] -= _amount;
            registered[msg.sender]= userInfo({
            userAddress: msg.sender,
            startAt: block.timestamp,
            funded: true,
            userAmount: _amount,
            budged: userBalance[msg.sender]
        });
        Token.transferFrom(msg.sender,address(this),_amount);
        userCount++;
       }
    }

    // function sawData() public view {}
    function cancel() public {
    userInfo memory user = registered[msg.sender];
    require(user.userAddress == msg.sender, "Your address is not correct.");
    uint256 amount = userBalance[msg.sender];
    delete(registered[msg.sender]) ;
    delete(userBalance[msg.sender]);
    require(Token.transfer(msg.sender,amount), "transaction failed.");

   }
   function milestone(uint256 _amount) public payable{
       userInfo memory user = registered[msg.sender];
       require(user.userAddress == msg.sender, "Your address is not correct.");
       require(block.timestamp >= user.startAt + 30 days, "Milestone payment is not started yet.");
       user.userAmount -= _amount;
       userBalance[msg.sender] -= _amount;
       Token.mint(msg.sender, _amount*5/100);
       require(Token.transfer(msg.sender,_amount), "transaction failed.");

   }
   function withdraw() public payable{
       userInfo memory user = registered[msg.sender];
       require(user.userAddress == msg.sender, "Your address is not correct.");
       require(block.timestamp >= user.startAt + 60 days, "Fund is still continue.");
       uint256 amount = userBalance[msg.sender];
       require(Token.transfer(msg.sender,amount), "transaction failed.");
       Token.mint(msg.sender, amount*10/100);
   }
   
}