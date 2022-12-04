// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol"; 
import "./NFTReward.sol";
// import "hardhat/console.sol";

contract WeFunder is NFTReward {
    //All Fundraisers Live Forever
    using Counters for Counters.Counter;
    Counters.Counter private _numOfFundRaisers;
    Counters.Counter private _idOfFundRaisers;

    event DonationSuccessful(address owner, uint256 amount, uint256 target);
    event FundRaiserCreated(address owner, uint256 target);

    struct FundRaiser {
        address payable owner;
        uint256 id;
        string title;
        string tag;
        string description;
        string images;
        uint256 target;
        uint256 totalDonations;
    }

    mapping(uint256 => FundRaiser) private idToFundRaiser;

    function CreateFundRaiser(uint256 target, string memory title, string memory tag, string memory description, string memory images) public {
        _idOfFundRaisers.increment();
        idToFundRaiser[_idOfFundRaisers.current()] = FundRaiser(
            payable(msg.sender),
            _idOfFundRaisers.current(),
            title,
            tag,
            description,
            images,
            target,
            0
        );
        _numOfFundRaisers.increment();
        emit FundRaiserCreated(msg.sender, target);
    }

    function GetAllFundRaisers() public view returns (FundRaiser[] memory) {
        uint256 currentCount = _numOfFundRaisers.current();
        FundRaiser[] memory fundRaisers = new FundRaiser[](currentCount);

        for (uint i = 0; i < currentCount; i++) {
            FundRaiser memory currentFundRaiser = idToFundRaiser[i+1];
            fundRaisers[i] = currentFundRaiser;
        }
        return fundRaisers;
    }

    function GetFundRaiserByAddress(address owner) public view returns (FundRaiser[] memory) {
        uint256 currentCount = _numOfFundRaisers.current();
        uint256 itemCount;
        uint256 currentIdx;

        for (uint i = 0; i < currentCount; i++) {
            if (idToFundRaiser[i+1].owner == owner) {
                itemCount++;
            }
        }

        FundRaiser[] memory fundRaisers =  new FundRaiser[](itemCount);
        for (uint i = 0; i < currentCount; i++) {
            FundRaiser memory currentFundRaiser = idToFundRaiser[i+1];
            if (currentFundRaiser.owner == owner) {
                fundRaisers[currentIdx] = currentFundRaiser;
                currentIdx++;
            }
        }
        return fundRaisers;
    }

    function GetFundRaiserByTag(string memory tag) public view returns (FundRaiser[] memory) {
        uint256 currentCount = _numOfFundRaisers.current();
        uint256 itemCount;
        uint256 currentIdx;

        for (uint i = 0; i < currentCount; i++) {
            if (keccak256(abi.encodePacked(idToFundRaiser[i+1].tag)) == keccak256(abi.encodePacked((tag)))) {
                itemCount++;
            }
        }

        FundRaiser[] memory fundRaisers =  new FundRaiser[](itemCount);
        for (uint i = 0; i < currentCount; i++) {
            FundRaiser memory currentFundRaiser = idToFundRaiser[i+1];
            if (keccak256(abi.encodePacked(currentFundRaiser.tag)) == keccak256(abi.encodePacked((tag)))) {
                fundRaisers[currentIdx] = currentFundRaiser;
                currentIdx++;
            }
        }
        return fundRaisers;
    }

    function DonateToFundraiser(uint256 _id) public payable {
        require(msg.value > 0, "Lol, You can't donate nothing bruv");
        require(idToFundRaiser[_id].totalDonations <= idToFundRaiser[_id].target, "target already met");
        idToFundRaiser[_id].owner.transfer(msg.value);
        idToFundRaiser[_id].totalDonations += msg.value;
        MintNFTReward(msg.sender, idToFundRaiser[_id].title);
        emit DonationSuccessful(idToFundRaiser[_id].owner, msg.value, idToFundRaiser[_id].target);
    }
}