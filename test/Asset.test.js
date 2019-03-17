const Asset = artifacts.require('Asset');
const BigNumber = web3.BigNumber

const emptyAddress = '0x0000000000000000000000000000000000000000';

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

contract('Test Asset', function ([_, owner_1, owner_2, trustee_1]) {
  beforeEach(async function () {
    // deploy token
    this.description = 'asset 1'
    this.asset = await Asset.new(owner_1, this.description)
  })

  describe('asset properties', function () {
    it('has the correct name', async function () {
      const description = await this.asset.description();
      assert.equal(description, this.description)
    })
    it('has the correct owner', async function () {
      const owner = await this.asset.owner();
      assert.equal(owner, owner_1)
    })
  });

  describe('asset transfer from owner to owner', function () {
    it('can pending set new pendingOwner', async function () {
      // tranfer when is owner_1 to owner_2
      const result = await this.asset.transfer(owner_2, { from: owner_1 })
      const pendingOwner = await this.asset.pendingOwner();
      assert.equal(pendingOwner, owner_2)
      assert.isTrue(result.logs.filter((log) => log.event == "PendingTransfer").length > 0)
    })

    it('can claim the asset to the new owner', async function () {
      await this.asset.transfer(owner_2, { from: owner_1 })
      const result = await this.asset.claim({ from: owner_2 })
      const pendingOwner = await this.asset.pendingOwner();
      // reset pendingOwner
      assert.equal(pendingOwner, emptyAddress)
      const owner = await this.asset.owner();
      // check new owner
      assert.equal(owner, owner_2)
      assert.isTrue(result.logs.filter((log) => log.event == "OwnershipTransferred").length > 0)
    })
  })

  describe('asset transfer from owner to _trustee', function () {
    it('aprove new trustee for the asset', async function () {
      const result = await this.asset.approve(trustee_1, { from: owner_1 })
      assert.isTrue(result.logs.filter((log) => log.event == "Approval").length > 0)
    });

    it('check _trustee allowance', async function () {
      await this.asset.approve(trustee_1, { from: owner_1 })
      const result = await this.asset.allowance(trustee_1, { from: owner_1 })
      assert.isTrue(result)
    });

    it('can pending owner to _trustee', async function () {
      await this.asset.approve(trustee_1, { from: owner_1 })
      const result = await this.asset.transferFrom(owner_2, { from: trustee_1 });
      const pendingOwner = await this.asset.pendingOwner();
      assert.equal(pendingOwner, owner_2)
      assert.isTrue(result.logs.filter((log) => log.event == "PendingTransfer").length > 0)
    });
  });

  //  TODO Pending destroy assets
  // describe('destroy asset', function () {
  //     it('destroy asset', async function () {
  //       const result = await this.asset.destroy();
  //       assert.isTrue(result.logs.filter((log)=> log.event == "AssetDestroyed").length > 0)
  //     });
  // })
});
