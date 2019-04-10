var OwnableAssetRegistry = artifacts.require("OwnableAssetRegistry");
var OwnableAsset = artifacts.require("OwnableAsset");

module.exports = function (deployer) {
  // deployer.deploy(OwnableAssetRegistry);
  deployer.deploy(OwnableAsset);
}
