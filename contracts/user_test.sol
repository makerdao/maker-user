import 'dapple/test.sol';
import 'interfaces.sol';

contract MakerUserTester is Tester {
    DSTokenBase token;

    function TokenProviderUserTester(DSTokenBase _token) {
        token = _token;
    }

    function doApprove(address to, uint amount) returns (bool) {
        return token.approve(to, amount);
    }
}

contract MakerUserTest is Test
                        , MakerUserGeneric(MakerTokenRegistry(0x0))
                        , TestFactoryUser
{
    uint constant issuedAmount = 1000;
    bytes32 constant daiName = "DAI";
    bytes32 constant ethName = "ETH";

    DSEthToken _eth;
    DSTokenBase _dai;
    MakerUserTester user1;
    TokenProviderUserTester user2;

    function setUp() {
        _eth = new DSEthToken();
        _dai = new DSTokenBase();
        _maker_tokens = new MakerTokenRegistry();
        _maker_tokens.set(ethName, bytes32(address(_dai)));
        _maker_tokens.set(daiName, bytes32(address(_dai)));

        user1 = new TokenProviderUserTester(_dai);
        user2 = new TokenProviderUserTester(_dai);
        user1._target(this);
        user2._target(this);
    }

    function testGetToken() {
        assertEq(getToken(daiName), _dai);
    }

    function testTotalSupply() {
        assertEq(totalSupply(daiName), issuedAmount);
    }

    function testAllowanceStartsAtZero() logs_gas {
        assertEq(allowance(user1, user2, daiName), 0);
    }

    function testValidTransfers() logs_gas {
        uint sentAmount = 250;
        transfer(user1, sentAmount, daiName);
        assertEq(balanceOf(user1, daiName), sentAmount);
        assertEq(balanceOf(this, daiName), issuedAmount - sentAmount);
    }

    function testFailInsufficientFundsTransfers() logs_gas {
        uint sentAmount = 250;
        transfer(user1, sentAmount, daiName);
        transferFrom(user1, user2, sentAmount+1, daiName);
    }

    function testApproveSetsAllowance() logs_gas {
        approve(user1, 25, daiName);
        assertEq(allowance(this, user1, daiName), 25,
                 "wrong allowance");
    }

    function testChargesAmountApproved() logs_gas {
        uint amountApproved = 20;
        user1.doApprove(this, amountApproved);
        transfer(user1, issuedAmount, daiName);
        assertTrue(transferFrom(user1, user2, amountApproved, daiName),
            "couldn't transferFrom");
        assertEq(balanceOf(user1, daiName), issuedAmount - amountApproved,
             "wrong balance after transferFrom");
    }

    function testFailUnapprovedTransfers() logs_gas {
        uint sentAmount = 250;

        transfer(user1, issuedAmount, daiName);
        transferFrom(user1, user2, sentAmount, daiName);
    }

    function testFailChargeMoreThanApproved() logs_gas {
        approve(user1, 20, daiName);
        transferFrom(this, user1, 21, daiName);
    }
}
