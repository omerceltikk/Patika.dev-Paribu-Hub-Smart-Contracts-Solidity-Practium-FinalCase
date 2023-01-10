//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "./ZetToken.sol";
import "./RewardNFT.sol";

contract ZetTokenFund {
    ZetToken public Token;
    RewardNFT public NFT;
    
    constructor(address _tokenAddress, address _nftaddress) {
        Token = ZetToken(_tokenAddress);
        NFT= RewardNFT(_nftaddress);
    }

    struct userInfo {
        address userAddress;
        uint256 startAt;
        bool funded;
        uint256 userAmount;
        uint256 budged;
    }
     
    userInfo[] public userList;
    mapping(address => uint256) public userBalance;
    
    function investMoney() public payable {
        require(msg.value > 0);
        Token.mint(msg.sender, msg.value);    
        userBalance[msg.sender] += Token.balanceOf(msg.sender);
    }

    function startFund(uint256 _amount) public payable {
        require(_amount > 0, "Amount can not be equal to zero.");
        userInfo memory user;

       if(!user.funded){
            userBalance[msg.sender] -= _amount;
            userList[userList.length-1]= userInfo({
            userAddress: msg.sender,
            startAt: block.timestamp,
            funded: true,
            userAmount: _amount,
            budged: userBalance[msg.sender]
            
        });
            Token.transferFrom(msg.sender,address(this),_amount);
            userList.push(user);
       }
    }

    function cancel() public payable{
    userInfo memory user = userList[userList.length-1];
    require(user.userAddress == msg.sender, "Your address is not correct.");
    
    uint256 amount = userBalance[msg.sender];
    Token.transferFrom(msg.sender, address(this), amount*1/100);
    delete(userBalance[msg.sender]);
    delete(userList[userList.length-1]);
    require(Token.transfer(msg.sender,amount), "transaction failed.");
   }

   function milestone(uint256 _amount) public {
       userInfo memory user = userList[userList.length-1];
       require(user.userAddress == msg.sender, "Your address is not correct.");
       require(block.timestamp >= user.startAt + 30 days, "Milestone payment is not started yet.");
       user.userAmount -= _amount;
       userBalance[msg.sender] -= _amount;
       Token.mint(msg.sender, _amount*5/100);
       require(Token.transfer(msg.sender,_amount), "transaction failed.");
   }

   function withdraw() public {
       userInfo memory user = userList[userList.length-1];

       require(user.userAddress == msg.sender, "Your address is not correct.");
       require(block.timestamp >= user.startAt + 60 days, "Fund is still continue.");
       
       uint256 amount = userBalance[msg.sender];
       require(Token.transfer(msg.sender,amount), "transaction failed.");
       Token.mint(msg.sender, amount*10/100);
   }

   function reward() public {
      userInfo memory user = userList[userList.length-1];
      require(user.userAddress == msg.sender, "Your address is not correct.");
      require(block.timestamp >= user.startAt + 60 days, "Fund is still continue.");
      NFT.safeMint(msg.sender);
   }
}
