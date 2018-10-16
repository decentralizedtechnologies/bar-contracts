var Asset = artifacts.require("../contracts/Asset.sol");
var AssetTrade = artifacts.require("../contracts/AssetTrade.sol");
var AssetSeries = artifacts.require("../contracts/AssetSeries.sol");
var AssetRegistry = artifacts.require("../contracts/AssetRegistry.sol");

const descriptionAsset  = 'Asset 1';

module.exports = function (deployer, network, [wallet_1]) {
  deployer.deploy(Asset, wallet_1, descriptionAsset);
  // deployer.deploy(AssetTrade);
  // deployer.deploy(AssetSeries);
  // deployer.deploy(AssetRegistry);
}
