const { assert } = require('chai')
const MyMarketPlaceCoin = artifacts.require('./MyMarketPlaceCoin')
require('chai')
  .use(require('chai-as-promised'))
  .should()
contract('MyMarketPlaceCoin', (accounts) => {
  let MyMarketPlaceCoin
  beforeEach(async () => {
    MyMarketPlaceCoin = await MyMarketPlaceCoin.deployed()
  })
  describe('deployment', async () => {
    it('deploys successfully', async () => {
      const address = MyMarketPlaceCoin.address
      assert.notEqual(address, 0x0)
      assert.notEqual(address, '')
      assert.notEqual(address, null)
      assert.notEqual(address, undefined)
    })
    it('has a name', async () => {
      const name = await MyMarketPlaceCoin.name()
      assert.equal(name, 'MyMarketPlaceCoin')
    })
    it('has a symbol', async () => {
      const symbol = await MyMarketPlaceCoin.symbol()
      assert.equal(symbol, 'ARTK')
    })
  })
  describe('minting', async () => {
    it('creates a new token', async () => {
      const result = await MyMarketPlaceCoin.mint('#EC058E')
      const event = result.logs[0].args
      const tokenId = event.tokenId.toNumber()
      const totalSupply = await MyMarketPlaceCoin.totalSupply()
      const item = await MyMarketPlaceCoin.Items(tokenId)
      const owner = await MyMarketPlaceCoin.ownerOf(tokenId)
      const approvedAddress = await MyMarketPlaceCoin.getApproved(tokenId)
      console.log(approvedAddress)
      //success
      assert.equal(tokenId, totalSupply, 'id is correct')
      assert.equal(item.uri, '#EC058E', 'color is correct')
      assert.equal(item.creator, owner, 'creator is correct')
      // assert.equal(approvedAddress, market.address, 'approved address is correct')
      assert.equal(event.from, '0x0000000000000000000000000000000000000000', 'from is correct')
      assert.equal(event.to, accounts[0], 'to is correct')
    })
  })
  describe('indexing', async () => {
    it('lists colors', async () => {
      //mint 3 more tokens
      await MyMarketPlaceCoin.mint('#5386E4')
      await MyMarketPlaceCoin.mint('#FFFFFF')
      await MyMarketPlaceCoin.mint('#000000')
      const totalSupply = await MyMarketPlaceCoin.totalSupply()
      let item
      let result = []
      for (var i = 1; i <= totalSupply; i++) {
        item = await MyMarketPlaceCoin.Items(i)
        result.push(item.uri)
      }
      let expected = ['#EC058E', '#5386E4', '#FFFFFF', '#000000']
      assert.equal(result.join(','), expected.join(','))
    })
  })
})