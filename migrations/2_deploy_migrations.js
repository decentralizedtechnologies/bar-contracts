var OwnableAssetRegistry = artifacts.require("OwnableAssetRegistry");

module.exports = function (deployer) {
  deployer.deploy(OwnableAssetRegistry);
}
