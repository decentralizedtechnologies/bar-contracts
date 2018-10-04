const Asset = artifacts.require('Asset');
const AssetTrade = artifacts.require('AssetTrade');
const BigNumber = web3.BigNumber

const emptyAddress =  '0x0000000000000000000000000000000000000000';

import ether from './helpers/ether'

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();


  contract('Test AssetTrade', function ([_, owner_1, owner_2, trustee_1]) {
    beforeEach(async function() {
      // deploy token
      this.description = 'asset 1'
      this.asset = await Asset.new(owner_1, this.description)
      this.assetTrade = await AssetTrade.new(this.asset.address)
    })

    describe('asset selling mechanism', function () {
      it('can sell', async function () {
        const value = ether(1);
        await this.assetTrade.sell(value, {from: owner_1})
        const price = await this.assetTrade.price()
        const state = await this.assetTrade.state()
        price.should.be.bignumber.equal(1000000000000000000)
        state.should.be.bignumber.equal(1)
      })

      // it('can buy', async function () {
      //   const value = ether(1);
      //   await this.assetTrade.sell(value, {from: owner_1})
      //   await this.assetTrade.buy()
      // })
    });
  });
