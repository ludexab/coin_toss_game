const CoinToss = artifacts.require("./CoinToss.sol");

contract("CoinToss contract", (accounts) => {
  it("Contract Deployment", async () => {
    const coinToss = CoinToss.deployed();
    assert(
      coinToss !== undefined,
      "coinToss contract instance should be defined"
    );
  });

  it("checking treasury balance", async () => {
    const coinToss = await CoinToss.deployed();
    const tres = await coinToss.treasury();
    assert.equal(
      tres.toString(),
      web3.utils.toWei("5", "ether"),
      "Treasury should equal tres"
    );
  });

  it("checking for deposit greater than treasury", async () => {
    const coinToss = await CoinToss.deployed();
    const deposit = await coinToss.sendMoney({
      from: accounts[0],
      value: web3.utils.toWei("2", "ether"),
    });
    const decision = deposit.logs[0].args.decision;
    const expectedDecision1 = "paying Nothing to The User";
    const expectedDecision2 = "Paying User Double of Sent Crypto";
    // Due to the probability nature of this transaction, only one of the two tests should pass at a time
    assert.equal(expectedDecision1, decision, "paying nothing");
    assert.equal(expectedDecision2, decision, "paying double");
  });
});
