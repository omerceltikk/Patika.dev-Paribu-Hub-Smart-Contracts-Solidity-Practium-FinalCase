//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "./ZetToken.sol";
import "./RewardNFT.sol";

contract ZetTokenFund {
    ZetToken public Token;
    RewardNFT public NFT;
    
    constructor(address payable _tokenAddress, address payable _nftaddress) {
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
    
    function investMoney(uint256 _amount) public payable {
        require(_amount > 0);
        userBalance[msg.sender] += _amount;
        payable(address(this)).transfer(_amount);
        Token.mint(msg.sender, _amount);    
    }

    function startFund(uint256 _amount) public {
        require(_amount > 0, "Amount can not be equal to zero.");
        userInfo memory user;

       if(user.funded == false){
            userBalance[msg.sender] -= _amount;
            userList[userList.length-1]= userInfo({
            userAddress: msg.sender,
            startAt: block.timestamp,
            funded: true,
            userAmount: _amount,
            budged: userBalance[msg.sender]
        });
            payable(address(this)).transfer(_amount);
            userList.push(user);
       }
    }

    function cancel() public {
    userInfo memory user = userList[userList.length-1];
    require(user.userAddress == msg.sender, "Your address is not correct.");
    uint256 amount = userBalance[msg.sender];
    delete(userBalance[msg.sender]);
    delete(userList[userList.length-1]);
    payable(msg.sender).transfer(amount*99/100);
   }

   function milestone(uint256 _amount) public {
       userInfo memory user = userList[userList.length-1];
       require(user.userAddress == msg.sender, "Your address is not correct.");
       require(block.timestamp >= user.startAt + 1 minutes, "Milestone payment is not started yet.");
       user.userAmount -= _amount;
       userBalance[msg.sender] -= _amount;
       Token.mint(msg.sender, _amount*5/100);
       payable(msg.sender).transfer(_amount);
   }

   function withdraw(uint256 _amount) public {
       userInfo memory user = userList[userList.length-1];

       require(user.userAddress == msg.sender, "Your address is not correct.");
       require(block.timestamp >= user.startAt + 1 minutes, "Fund is still continue.");
       
       payable(msg.sender).transfer(_amount);
       Token.mint(msg.sender, _amount*10/100);
   }

   function reward() public {
      userInfo memory user = userList[userList.length-1];
      require(user.userAddress == msg.sender, "Your address is not correct.");
      require(block.timestamp >= user.startAt + 1 minutes, "Fund is still continue.");
      NFT.safeMint(msg.sender);
   }

}
