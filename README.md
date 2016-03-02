Quickly build dai apps w/ `dapple` and `MakerUser`
---

#### Prerequisites

The only mandatory requirement is `npm`. In order to deploy contracts,
you'll need an Ethereum client like `geth`. If you have a local installation
of `solc`, compiling your contracts will be 5-10x faster.

    $ npm -v
    3.5.3

    $ geth version
    Geth
    Version: 1.3.3

    $ solc --version
    solc, the solidity compiler commandline interface
    Version: 0.2.0-d21c4276/RelWithDebInfo-Linux/g++/int linked to libethereum-1.1.1-eece77c8/RelWithDebInfo-Linux/g++/int


#### Install Dapple

First, get `dapple` via `npm`:

    npm install -g dapple

#### Create a dapple package

    mkdir mydapp && cd mydapp
    dapple init

#### Install `makeruser` package

    dapple install makeruser 0.1.0

Now you have access to the `MakerUser` mixin contract.

A mixin is a contract with only internal functions - it is not an abstract contract (an interface),
but the compiler will only emit anything if you use one of the internal functions in a derived contract.

Let's create a simple one-off betting contract. A creator specifies a judge, who is
trusted to resolve the bet according to the given terms (specified via IPFS hash).
Anyone can accept the bet.

This first version will only make use of the helpers that correspond directly with ERC20 functions.
Later we will see how it can be shortened significantly using some other common patterns.

    import 'makeruser/user.sol';

    contract SimpleBet is MakerUser
    {
        address public _creator;
        address public _better;
        address public _judge
        bytes   public _terms_hash;
        bool    public _creator_bet;
        uint    public _creator_bet_amount;
        uint    public _required_bet_amount;
        uint    public _fee;
        bool    public _init;
        bool    public _bet;
        bool    public _done;
        function SimpleBet( address judge
                          , uint judge_fee
                          , uint creator_bet_amount
                          , uint required_bet_amount
                          , uint expiration )
        {
            _creator = msg.sender;
            _creator_bet_amount = creator_bet_amount;
            _required_bet_amount = required_bet_amount;
            _judge = judge;
            _fee = judge_fee;
        }
        function fund() {
            transferFrom( msg.sender, this, _creator_bet_amount, "DAI" );
            _init = true;
        }
        function takeBet() {
            if( !_init ) throw;
            transferFrom( msg.sender, this, _required_bet_amount, "DAI" );
            _better = msg.sender;
            _bet = true;
        }
        function resolve(bool result) {
            if( !_bet ) throw;
            if( msg.sender != _judge ) throw;

            transfer( _judge, _fee, "DAI" );

            var winnings = _creator_bet_amount + _required_bet_amount - _fee;
            if( _creator_bet && result ) {
                transfer( _creator, winnings, "DAI");
            } else {
                transfer( _better, winnings, "DAI");
            }
            selfdestruct(msg.sender);
        }
    }
}
