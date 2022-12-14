pragma solidity >=0.4.0 <0.6.2;

// accepts a bid from a bidder and stores the bid into a list,
// the bidder can recall or cancel their bids at anytime. Auctioneer can EndBid.

contract Auction {

// the one auctioning the item
address public Auctioneer;

// the name of the Auction
string auctionName;

struct Bid {
// bid is connected to an address

address payable bidderAddress;
uint amount; // value variables in Solidity are always stored as the wei value
string name;
bool valid; // is the bid valid

}

// array of bids

Bid[] public bids;

// set the name of the auction
constructor(string memory _name)
public {
auctionName = _name;
Auctioneer = msg.sender;
}

// returns how many bids have been made on the item
function getNumberOfBids()
public
view
returns (uint numberOfBids) {
uint256 a = 0;
for(uint i = 0; i < bids.length; i++) {
if (bids[i].amount > 0) {
a= a+1;
}
}
return a;
}

// returns the ID of the highestBID
function getHighestBidID() public view
returns (uint bidID) {

// there has to be atleast one bid placed

require(bids.length > 0);

// finds the highest bids ID #

uint highestAmount = 0;
uint highestID = 0;

for (uint i=0; i<bids.length; i++) {
if (bids[i].amount > highestAmount) {
highestAmount = bids[i].amount;
highestID = i;
}
}
return highestID;
}

// call this function make a Bid for the proposed function
function makeBid(string calldata _name) external payable
returns(uint bidIterator) {

require(msg.value > 0);

bids.push(Bid(msg.sender, msg.value, _name, true));

return bids.length - 1;
}

// returns the value of the bid to the specified address of the msg.sender

function recallBid(uint bidIterator)
external {
require(bidIterator < bids.length, "Invalid bidIterator");
require(msg.sender == bids[bidIterator].bidderAddress, "msg.sender !=
bidderAddress");

require(bids[bidIterator].valid, "Bid is invalid; aborting";);

uint amountToSend = bids[bidIterator].amount;
bids[bidIterator].amount = 0;
bids[bidIterator].valid = false;
bids[bidIterator].bidderAddress.transfer(amountToSend);
}
function endAuction() public {
selfdestruct(msg.sender);
}

}
