// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract DecentralizedMarketplace {
    struct Item {
        uint256 id;
        string name;
        uint256 price;
        address payable seller;
        address buyer;
        bool sold;
    }

    mapping(uint256 => Item) public items;
    mapping(address => uint256[]) public ownership;
    uint256 public itemCount;

    event ItemListed(uint256 id, string name, uint256 price, address indexed seller);
    event ItemPurchased(uint256 id, address indexed buyer);
    event FundsWithdrawn(address indexed seller, uint256 amount);

    constructor() {
        itemCount = 0;
    }

    function listItem(string memory _name, uint256 _price) public {
        require(bytes(_name).length > 0, "Item name is required");
        require(_price > 0, "Price must be greater than zero");

        itemCount++;
        items[itemCount] = Item(itemCount, _name, _price, payable(msg.sender), address(0), false);

        emit ItemListed(itemCount, _name, _price, msg.sender);
    }

    function purchaseItem(uint256 _itemId) public payable {
        require(_itemId > 0 && _itemId <= itemCount, "Item does not exist");
        Item storage item = items[_itemId];
        require(!item.sold, "Item already sold");
        require(msg.value == item.price, "Incorrect value sent");

        item.buyer = msg.sender;
        item.sold = true;
        ownership[msg.sender].push(_itemId);

        emit ItemPurchased(_itemId, msg.sender);
    }

    function withdrawFunds() public {
        uint256 total = 0;
        for (uint256 i = 1; i <= itemCount; i++) {
            if (items[i].seller == msg.sender && items[i].sold && items[i].buyer != address(0)) {
                total += items[i].price;
                items[i].buyer = address(0);  // Mark as withdrawn
            }
        }
        require(total > 0, "No funds to withdraw");
        payable(msg.sender).transfer(total);

        emit FundsWithdrawn(msg.sender, total);
    }

    function getItemsOwned(address _owner) public view returns (uint256[] memory) {
        return ownership[_owner];
    }
}