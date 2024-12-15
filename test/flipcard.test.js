FlipCard = artifacts.require("./FlipCard");


contract('FlipCard', (accounts) => {
    let contract;
    let chai;

    before(async () => {
        // Dynamically import chai
        chai = await import('chai');

        // Dynamically import chai-as-promised and use it as a plugin
        const chaiAsPromised = await import('chai-as-promised');
        chai.use(chaiAsPromised.default);  // Ensure correct usage of default export

        chai.should();  // Enable chai should assertions

        contract = await FlipCard.deployed();
    });

    // testing container
    describe('deployment', async () => {
        // test samples with it
        it('deploys successfully', async () => {
            const address = contract.address;
            chai.assert.notEqual(address, 0x0);
            chai.assert.notEqual(address, '');
            chai.assert.notEqual(address, null);
            chai.assert.notEqual(address, undefined); 
        });

        // name matching or not
        it('name matched', async () => {
            const name = await contract.name();
            chai.assert.equal(name, 'FlipCard');
        });

        // symbol matching or not
        it('symbol matched', async () => {
            const symbol = await contract.symbol();
            chai.assert.equal(symbol, 'FC');
        });  
    });

    describe('minting', async () => {
        it('creating new token', async () => {
            // Define all the required parameters
            const flipcard = 'https://someurl.com/1';
            const serialNumber = 'SN12345';
            const email = 'test@example.com';
            const mobileNumber = '1234567890';
            const itemName = 'FlipCardItem';
            const expiryMonths = 12;
    
            // Call the mint function with all the parameters
            const result = await contract.mint(flipcard, serialNumber, email, mobileNumber, itemName, expiryMonths, { from: accounts[0] });
    
            // Check the total supply
            const totalSupply = await contract.totalSupply();
    
            // Success
            chai.assert.equal(totalSupply, 1);
    
            // Check event for minting (adjust based on actual event logs)
            const event = result.logs[0].args;
            console.log(event)
            chai.assert.equal(event._to, accounts[0], 'to address is correct');

            // Failure: Attempt to mint a duplicate flipcard
            await contract.mint(flipcard, serialNumber, email, mobileNumber, itemName, expiryMonths, { from: accounts[0] }).should.be.rejected;
        });
    });
    
    describe('indexing', async () => {
        it('lists cards', async () => {
            // Define all the required parameters for minting
            const flipcard1 = 'https://someurl.com/5';
            const serialNumber1 = 'SN12345';
            const email1 = 'test1@example.com';
            const mobileNumber1 = '1234567890';
            const itemName1 = 'Item1';
            const expiryMonths1 = 12;
    
            const flipcard2 = 'https://someurl.com/2';
            const serialNumber2 = 'SN12346';
            const email2 = 'test2@example.com';
            const mobileNumber2 = '1234567891';
            const itemName2 = 'Item2';
            const expiryMonths2 = 12;
    
            const flipcard3 = 'https://someurl.com/3';
            const serialNumber3 = 'SN12347';
            const email3 = 'test3@example.com';
            const mobileNumber3 = '1234567892';
            const itemName3 = 'Item3';
            const expiryMonths3 = 12;
    
            const flipcard4 = 'https://someurl.com/4';
            const serialNumber4 = 'SN12348';
            const email4 = 'test4@example.com';
            const mobileNumber4 = '1234567893';
            const itemName4 = 'Item4';
            const expiryMonths4 = 12;
    
            // Minting cards
            await contract.mint(flipcard1, serialNumber1, email1, mobileNumber1, itemName1, expiryMonths1, { from: accounts[0] });
            await contract.mint(flipcard2, serialNumber2, email2, mobileNumber2, itemName2, expiryMonths2, { from: accounts[0] });
            await contract.mint(flipcard3, serialNumber3, email3, mobileNumber3, itemName3, expiryMonths3, { from: accounts[0] });
            await contract.mint(flipcard4, serialNumber4, email4, mobileNumber4, itemName4, expiryMonths4, { from: accounts[0] });
    
            // Verify the total supply
            const totalSupply = await contract.totalSupply();
            chai.assert.equal(totalSupply, 4);
    
            // Indexing all flipcards
            let result = [];
            for (let i = 0; i < totalSupply; i++) {
                const flipcard = await contract.flipCards(i);
                result.push(flipcard);
            }
    
            // Define expected results
            const expected = [flipcard1, flipcard2, flipcard3, flipcard4];
            chai.assert.equal(result.join(','), expected.join(','), 'flipcards are correct');
        });
    });
    
});
