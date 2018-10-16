const AssetSeries = artifacts.require('AssetSeries');
const BigNumber = web3.BigNumber

const emptyAddress =  '0x0000000000000000000000000000000000000000';

import ether from './helpers/ether'

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

  contract('Test function AssetSeries', function ([_, issuer_1, owner_2, trustee_1]) {
    beforeEach(async function() {
      // deploy token
      this.serialNumber = 99999
      this.limit = 10
      this.description = 'asset serie 1'
      this.description2 = 'asset series 2'
      this.assetSeries = await AssetSeries.new(issuer_1,this.serialNumber, this.limit, this.description)
    })
    describe('create asset series', function () {
      it('can create', async function () {
        await this.assetSeries.newAsset(this.description2, {from: issuer_1})
      })
    })
  })
