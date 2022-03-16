// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./weathlToken.sol";

contract Airdrop {

IERC721 public WEATHL;
    mapping(address=>uint256) public Percentage;

    event TransferPercentage(address indexed to, uint256 value);
    event FailedTransfers(address indexed to, uint256 value);

     
    modifier DropActive() {
        assert(isDropActive());
      _;
    }

    function isDropActive() public view returns (bool) {
        return (tokensAvailable() > 0);
    }

    function tokensAvailable() public view returns (uint256){
        return WEATHL.balanceOf(this);
    }

    function sendTokensInternally(address recipient, uint256 tokensToSend, uint256 valuePresented) internal {
        if (recipient == address(0)) return;

        if (tokensAvailable() >= tokensToSend) {
            WEATHL.transfer(recipient, tokensToSend);
            emit TransferPercentage(recipient, valuePresented);
        } else {
            emit FailedTransfers(recipient, valuePresented); 
        }
    }   

    //uint256 j;
    
    function AirdropTokens(address[] dests) external whenDropIsActive onlyOwner {

    for(uint256 j=0,j<dests.length,j+=1){
         uint256[j] values = WEATHL.GetTokenPercentage(msg.sender);
    }

        uint i = 0;
        while (i < dests.length) {
            uint256 toSend = values[i] * 10**18;
            sendInternally(dests[i], toSend, values[i]);
            WEATHL.safeBurnAndModify(msg.sender);
            i += 1;
        } 
    } 

}

