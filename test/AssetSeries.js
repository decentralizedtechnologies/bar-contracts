const Asset = artifacts.require('Asset')
const AssetSeries = artifacts.require('AssetSeries')

contract('AssetSeries', function ([creator, creator2]) {

  before(async function () {
    this.Asset = await Asset.deployed()
    await this.Asset.initialize({from: creator})
    this.AssetSeries = await AssetSeries.deployed()
    await this.AssetSeries.initialize(this.Asset, {from: creator})
  });

  it('AssetSeries is owner of Asset contract', async function () {

    const owner = await this.Asset.owner.call()
    assert.equal(owner, this.AssetSeries.address)
  })

  it('Creates series with limit, name and description', async function () {
    const limit = 3
    const name = 'Asset series no. 1'
    const description = 'Asset no. 1'

    await this.AssetSeries.createSeries(limit, name, description, { from: creator })

    const series = await this.AssetSeries.getSeriesByIdFromCreator.call(creator, 1)

    const [ _id, _limit, _name, _description, _creator, _items ] = series

    assert.equal(_id.valueOf(), 1)
    assert.equal(_limit.valueOf(), 3)
    assert.equal(_name, name)
    assert.equal(_description, description)
    assert.equal(_creator, creator)
    assert.equal(typeof _items, 'object')
    assert.equal(_items.length, 0)
  })

  it('Creates 2nd series and adds assets', async function () {
    const limit = 2
    const name = 'Asset series no. 2'
    const description = 'Asset no. 2'

    await this.AssetSeries.createSeries(limit, name, description, {from: creator2})

    const seriesIds = await this.AssetSeries.getSeriesIdsFromAddress.call(creator2)
    const [ seriesId2 ] = seriesIds
    const series = await this.AssetSeries.getSeriesByIdFromCreator.call(creator2, seriesId2)
    const [ _id, _limit, _name, _description, _creator, _items ] = series
    console.log(_creator)
    console.log(_id.valueOf())

    // const currentItemBySeriesId = await this.Asset.currentItemBySeriesId.call(seriesId2)
    // console.log(currentItemBySeriesId)

    await this.AssetSeries.addAsset(_id, { from: _creator })

    // const assetsBySeriesId = this.AssetSeries.getAssetsBySeriesId.call(_id, _creator)

    // console.log(assetsBySeriesId)
  })
});








