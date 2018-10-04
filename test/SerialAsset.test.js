const SerialAsset = artifacts.require('SerialAsset');
const BigNumber = web3.BigNumber

const emptyAddress =  '0x0000000000000000000000000000000000000000';

import ether from './helpers/ether'

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();


  contract('Test SerialAsset', function ([_, owner_1, owner_2, trustee_1]) {
    describe('create asset', function () {
      it('can create asset', async function () {
        SerialAsset.new()
      })
    })
  })
