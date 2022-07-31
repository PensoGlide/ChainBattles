const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("Lock", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshopt in every test.
  async function deployOneYearLockFixture() {
    const [owner, otherAccount] = await ethers.getSigners();

    const ChainBattles = await ethers.getContractFactory("ChainBattles");
    const chainBattles = await ChainBattles.deploy();

    return { chainBattles, owner, otherAccount };
  }

  describe("Deployment", function () {
    it("Should mint", async function () {
      await chainBattles.mint
    });
  });
});
