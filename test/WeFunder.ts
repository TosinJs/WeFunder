import { expect } from "chai";
import { ethers } from "hardhat";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import "@nomicfoundation/hardhat-chai-matchers";

describe("WeFunder", async function() {
    async function deployWeFunder() {
        const [myAddress, address1, address2] = await ethers.getSigners()
        const WeFunderContractFactory = await ethers.getContractFactory("WeFunder")
        const WeFunderContract = await WeFunderContractFactory.deploy()
        await WeFunderContract.deployed()
        
        return { WeFunderContract, myAddress, address1, address2 }
    }

    describe("create fund raiser", async function() {
        it("should create fund raiser", async function() {
            const { WeFunderContract } = await deployWeFunder()
            await WeFunderContract.CreateFundRaiser(500, "filing", "animal", "new FUnd Raiser", "image")
        })
        it("should create four fundraisers", async function() {
            const { WeFunderContract } = await deployWeFunder()
            await WeFunderContract.CreateFundRaiser(500, "filing", "animal", "new Fund Raiser", "image")
            await WeFunderContract.CreateFundRaiser(500, "filing", "animal", "new Fund Raiser", "image")
            await WeFunderContract.CreateFundRaiser(500, "filing", "animal", "new Fund Raiser", "image")
            const funders = await WeFunderContract.GetAllFundRaisers()
            expect(funders.length).to.equal(3)
        })
    })

    describe("get fund raiser by address", async function() {
        it("should return an array of fund raisers", async function() {
            const { WeFunderContract, myAddress, address1 } = await deployWeFunder()
            await WeFunderContract.CreateFundRaiser(500, "filing", "animal", "a fund raiser", "image")
            await WeFunderContract.CreateFundRaiser(500, "filing", "animal", "a fund raiser", "image")
            await WeFunderContract.connect(address1).CreateFundRaiser(500, "filing", "animal", "a fund raiser", "image")
            const myFunders = await WeFunderContract.GetFundRaiserByAddress(myAddress.address)
            const theirFunders = await WeFunderContract.GetFundRaiserByAddress(address1.address)
            expect(myFunders.length).to.equal(2)
            expect(theirFunders.length).to.equal(1)
        })
    })

    describe("get fund raiser by tag", async function() {
        it("should return an array of fund raisers", async function() {
            const { WeFunderContract, address1 } = await deployWeFunder()
            await WeFunderContract.CreateFundRaiser(500, "filing", "animal", "a fund raiser", "image")
            await WeFunderContract.CreateFundRaiser(500, "filing", "animal", "a fund raiser", "image")
            await WeFunderContract.connect(address1).CreateFundRaiser(500, "filing","health", "a fund raiser", "image")
            const animalFunders = await WeFunderContract.GetFundRaiserByTag("animal")
            const healthFunders = await WeFunderContract.GetFundRaiserByTag("health")
            expect(animalFunders.length).to.equal(2)
            expect(healthFunders.length).to.equal(1)
        })
    })
    
    describe("donate to fund raiser", async function() {
        it("should increase the amount donated", async function() {
            const { WeFunderContract, myAddress, address1 } = await deployWeFunder()
            await WeFunderContract.CreateFundRaiser(1, "filing", "animal", "a fund raiser", "image")
            await WeFunderContract.connect(address1).DonateToFundraiser(1, { value: ethers.utils.parseEther("500") })
            
            const myFunders = await WeFunderContract.GetFundRaiserByAddress(myAddress.address)

            expect(myFunders[0].totalDonations.toString()).to.equal(ethers.utils.parseEther("500").toString())
        })

        it("should return nft tokenId", async function() {
            const { WeFunderContract, address1 } = await deployWeFunder()
            await WeFunderContract.CreateFundRaiser(1, "filing", "animal", "a fund raiser", "image")
            await WeFunderContract.connect(address1).DonateToFundraiser(1, { value: ethers.utils.parseEther("0.2") })
            await expect(WeFunderContract.DonateToFundraiser(1, { value: ethers.utils.parseEther("0.2") }))
                .to.emit(WeFunderContract, "NFTRewardMinted")
                .withArgs(anyValue, 1)
        })

        it("should reject if target is met", async function() {
            const { WeFunderContract, address1 } = await deployWeFunder()
            await WeFunderContract.CreateFundRaiser(1, "filing", "animal", "a fund raiser", "image")
            await WeFunderContract.connect(address1).DonateToFundraiser(1, { value: ethers.utils.parseEther("500") })

            await expect(WeFunderContract.connect(address1).DonateToFundraiser(1, { value: ethers.utils.parseEther("500") })).to.be.revertedWith("target already met")
        })
    })
    }
)