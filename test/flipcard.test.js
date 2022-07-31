const {assert} = require('chai');

FlipCard = artifacts.require("./FlipCard");

require('chai')
    .use(require('chai-as-promised'))
    .should();

contract('FlipCard', (accounts) => {
    let contract;

    before(async () =>{
      contract = await FlipCard.deployed()
    })


    // testing container
    describe('deployment', async () => {
        // test samples with it
        it('deploys successfully', async () => {
            const address = contract.address;
            assert.notEqual(address, 0x0);
            assert.notEqual(address, '');
            assert.notEqual(address, null);
            assert.notEqual(address, undefined); 
        })

        //name matching or not
        it('name matched', async () => {
            const name = await contract.name();
            assert.equal(name, 'FlipCard');
        })

        //symbol matching or not
        it('symbol matched', async () => {
            const symbol = await contract.symbol();
            assert.equal(symbol, 'FC');
        })  
    })


    // minting test
    describe('minting', async () => {
        // test samples with it
        it('creating new token', async () => {
            const result = await contract.mint('https...1');
            const totalSupply = await contract.totalSupply();

            //success
            assert.equal(totalSupply, 1);
            const event = result.logs[0].args;
            assert.equal(event._to, accounts[0], 'to address is correct');

            //failure
            await contract.mint('https...1').should.be.rejected;
        });
    })


    // indexing
    describe('indexing', async () => {
        it('lists cards', async () => {
            await contract.mint('https...2');
            await contract.mint('https...3');
            await contract.mint('https...4');
            const totalSupply = await contract.totalSupply();
            assert.equal(totalSupply, 4);

            
        let result = [];
        let flipcard
        for(let i = 0; i < totalSupply; i++){
            flipcard = await contract.flipCards(i);
            result.push(flipcard);
        }

        let expected = ['https...1','https...2','https...3','https...4'];
        assert.equal(result.join(','),expected.join(','),'flipcards are correct');
        })

    })


    
})