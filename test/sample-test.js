const { ethers, waffle } = require("hardhat");
const { expect, use } = require("chai");
const { solidity } = require("ethereum-waffle");
const { BigNumber, utils, provider } = ethers;

use(solidity);

const ZERO = new BigNumber.from("0");
const ONE = new BigNumber.from("1");
const ONE_ETH = utils.parseUnits("1", 5);
const LESS_ETH = utils.parseUnits("0.1", 5);
const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";
const MAX_UINT = "115792089237316195423570985008687907853269984665640564039457584007913129639935";

let committee, deployer, user1, user2, user3;

describe("Committee", () => {
    it("It should deploy committe contract and make ethers available ", async () => {
        [deployer, user1, user2, user3] = await ethers.getSigners();

        const committeeContract = await ethers.getContractFactory("Committee");
        committee = await committeeContract.deploy();
        // deployer = committee.from;
    });
    it("it should let user1 enter", async () => {
        const res = await committee.connect(user1).newEntries({ value: ethers.utils.parseEther("0.1") });
        // await expect(committee.connect(user1).newEntries({ value: ethers.utils.parseEther("0.1") })).to.emit(true);
    });
    it("it should let user2 enter", async () => {
        const res = await committee.connect(user2).newEntries({ value: ethers.utils.parseEther("0.1") });
        // await expect(committee.connect(user1).newEntries({ value: ethers.utils.parseEther("0.1") })).to.emit(true);
    });
    it("it should select winner", async () => {
      const res = await expect(committee.connect(deployer).choseWinner()).to.be.not.reverted;
      console.log(res);
    });
    it("it should let user1 ReEnter", async () => {
        const res = await committee.connect(user1).ReEnter({ value: ethers.utils.parseEther("0.1") });
        // await expect(committee.connect(user1).newEntries({ value: ethers.utils.parseEther("0.1") })).to.emit(true);
    });
    it("it should let user2 ReEnter", async () => {
        const res = await committee.connect(user2).ReEnter({ value: ethers.utils.parseEther("0.1") });
        // await expect(committee.connect(user1).newEntries({ value: ethers.utils.parseEther("0.1") })).to.emit(true);
    });
    xit("it should not let user1 enter", async () => {
        await expect(committee.connect(user1).newEntries({ value: ethers.utils.parseEther("0.01") })).to.be.reverted;
        console.log("passed");
    });
    xit("it should not allow reEntry to user1", async () => {
        const res = await expect(committee.connect(user1).ReEnter({ value: ethers.utils.parseEther("0.1") })).to.be.reverted;
    });
    it("it should select winner", async () => {
        const res = await expect(committee.connect(deployer).choseWinner()).to.be.not.reverted;
        console.log(res);
    });
});
