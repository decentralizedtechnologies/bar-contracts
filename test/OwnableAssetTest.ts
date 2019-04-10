const OwnableAsset = artifacts.require('OwnableAsset');
const emptyAddress = '0x0000000000000000000000000000000000000000';

contract('OwnableAsset Test', async ([wallet1, wallet2, wallet3]) => {

  it('should set the owner to the contract creator', async () => {
    const contract = await OwnableAsset.deployed()
    const owner = await contract.owner()
    const owners = await contract.owners()

    console.log(owner, wallet1, owners);
    assert.equal(owner, wallet1);
    assert.equal(owner, owners[0]);
  })

  it('should set a pending owner with the transferOwnership method', async () => {
    const contract = await OwnableAsset.deployed()
    await contract.transferOwnership(wallet2)
    const owner = await contract.owner()
    const pendingOwner = await contract.pendingOwner()

    console.log(owner, wallet1, pendingOwner, wallet2);
    assert.equal(pendingOwner, wallet2);
  })

  it('should claimOwnership only by a pendingOwner', async () => {
    const contract = await OwnableAsset.deployed()
    await contract.transferOwnership(wallet2)
    const prevOwner = await contract.owner()
    await contract.claimOwnership({
      from: wallet2,
    })
    const newOwner = await contract.owner()
    const owners = await contract.owners()
    const pendingOwner = await contract.pendingOwner()

    console.log(prevOwner, pendingOwner, newOwner, owners);
    assert.equal(prevOwner, wallet1);
    assert.equal(prevOwner, owners[0]);
    assert.equal(newOwner, wallet2);
    assert.equal(newOwner, owners[1]);
    assert.equal(pendingOwner, emptyAddress, "_pendingOwner must be an empty address");
  })

});
