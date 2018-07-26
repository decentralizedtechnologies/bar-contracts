var AssetSeries = artifacts.require("../contracts/AssetSeries.sol");
var Asset = artifacts.require("../contracts/Asset.sol");

module.exports = function(deployer) {
  deployer.deploy(Asset);
  deployer.deploy(AssetSeries);
}