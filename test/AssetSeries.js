import { TestApp } from 'zos';

const AssetSeries = artifacts.require('AssetSeries')

contract('AssetSeries', function ([owner, _]) {

  beforeEach(async function () {
    this.app = await TestApp('zos.json', { from: owner })
  });

  it('should create a proxy for the stdlib', async function () {
    const proxy = await this.app.createProxy(AssetSeries);
  })
});