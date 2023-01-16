//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "./ZetToken.sol";
import "./Items.sol";
import "./RewardNFT.sol";

contract ZetTokenGame{
    ZetToken public Token;
    Items public items;
    RewardNFT public rewardNFT;
    uint256 public playerCount;

    constructor(address _tokenAddress, address _itemAddress, address _rewardNFTaddress) {
        Token = ZetToken(_tokenAddress);
        items = Items(_itemAddress);
        rewardNFT = RewardNFT(_rewardNFTaddress);

        addItem("copper",0,10000000000000000);
        addItem("silver",1,100000000000000000);
        addItem("gold",2,1000000000000000000);
        addItem("diamond",3,15000000000000000000);
    
    } 
    
    function addItem(string memory _name, uint256 _id, uint256 _price) private {
        Item memory item;
        item.name = _name;
        item.id = _id;
        item.price= _price;
        itemsId[_id] = item;
    }

    struct Item {
        uint256 id;
        uint256 price;
        string name;
    }
    
    struct User {
        uint256 id;
        address userAddress;
        uint256 startAt;
        bool level1;
        bool level2;
        bool level3;
    }

    User[] public rewardList;
    mapping(address => User) public userList;
    mapping(uint256 => Item) public itemsId;

    function investTokens(uint256 _amount) public payable {
        require(_amount > 0);
        Token.mint(msg.sender, _amount);
    }

    function gameStart() public {
        require(userList[msg.sender].id == 0, "you have already registered");
        User memory user;
        user.id == playerCount++;
        user.userAddress = msg.sender;
        userList[msg.sender] = user;
    }
    function buyItem(uint _id, uint _amount) public{
        require(Token.balanceOf(msg.sender) >= _amount * itemsId[_id].price, "you have not enough Token" );
        Token.burnFrom(msg.sender, _amount * itemsId[_id].price );
        items.mint(msg.sender, _id, _amount, "");
    }
    function sellItem(uint _id, uint _amount) public {
        require(items.balanceOf(msg.sender, _id) >= _amount );
        items.burn(msg.sender, _id, _amount);
        Token.mint(msg.sender, _amount * itemsId[_id].price );
    }
     function prepareToken() public {
        User memory user;
        require(userList[msg.sender].startAt == 0 );
        require(items.balanceOf(msg.sender, 0) >= 5);
        items.burn(msg.sender, 0, 5);
        
        if(user.level1){
            require(items.balanceOf(msg.sender, 1) >= 5);
             items.burn(msg.sender, 1, 5);
        }
        if(user.level2){
            require(items.balanceOf(msg.sender, 2) >= 5);
            items.burn(msg.sender, 2, 5);
        }
        userList[msg.sender].startAt = block.timestamp;
        }

    function takeToken() public {
            User memory user;
            if( block.timestamp <=  userList[msg.sender].startAt + 1 minutes) {
            revert("not yet");
        }else{
        items.mint(msg.sender, 1, 1, "");
        userList[msg.sender].startAt = 0;
        user.level1 = true;
        }
        if((user.level1) && block.timestamp <=  userList[msg.sender].startAt + 1 minutes){
            revert("not yet");
        }else{
        items.mint(msg.sender, 2, 1, "");
        userList[msg.sender].startAt = 0;
        user.level2 = true;
        }
         if((user.level2) && block.timestamp <=  userList[msg.sender].startAt + 1 minutes){
            revert("not yet");
        }else{
        items.mint(msg.sender, 3, 1, "");
        userList[msg.sender].startAt = 0;
        user.level3 = true;
        rewardList.push(user);
        }
        }

function reward() public {
    User memory user;
    if((user.level3) && rewardList[rewardList.length-1].id < 500){
        rewardNFT.safeMint(msg.sender);
    }
}

}