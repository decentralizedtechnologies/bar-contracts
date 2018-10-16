const Asset = artifacts.require('Asset');
const AssetRegistry = artifacts.require('AssetRegistry');
const BigNumber = web3.BigNumber

const emptyAddress =  '0x0000000000000000000000000000000000000000';

import ether from './helpers/ether'

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();


  contract('Test Asset Registry', function ([_, owner_1, owner_2, trustee_1]) {
    beforeEach(async function() {
      this.description = 'asset 1'
      this.assetRegistry = await AssetRegistry.new()
    })

    describe('registrying asset', function () {
      it('add registry', async function () {
          const result = await this.assetRegistry.newAsset(this.description)
          assert.isTrue(result.logs.filter((log)=> log.event == "CreatedAsset").length > 0)
      })
    })
  });
