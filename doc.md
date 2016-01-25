Quickly build dai apps w/ `dapple` and `MakerUser`
---

#### Prerequisites

The only mandatory prerequisite is `npm`. In order to deploy contracts,
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

#### Create a basic contract with a test

TODO ryan

#### Install `makeruser` package

    dapple install https://github.com/MakerDAO/makeruser maker

Note we are aliasing it to `maker` though its default name is `makeruser`.

Now you have access to the `MakerUser` mixin contract.

A mixin is a contract with only internal functions - it is not an abstract contract (an interface),
but the compiler will only emit anything if you use one of the internal functions in a derived contract.


Let's create a simple one-off betting contract. A creator specifies a judge, who is
trusted to resolve the bet according to the given terms (specified via IPFS hash).
Anyone accepts the bet

    import 'maker/user.sol';

    contract SimpleBet is MakerUser
    {
        address public _creator;
        address public _buyer;
        address public _judge
        bytes public terms;
        bool     _creator_bet;
        uint     _creator_bet_amount;
        uint     _required_bet_amount;
        uint     _fee;
        bool     _done;
        function MyRegistry( address judge
                           , uint judge_fee
                           , uint creator_bet_amount
                           , uint want_bet_amount
                           , uint expiration )
        {
            var my_dai_allowance = allowance(address(this), msg.sender, "DAI");
            var initial_dai_required = creator_bet_amount + (fee / 2);
            _creator = msg.sender;
            _judge = judge;
        }
        function takeBet()
                 costs( 
        function resolve() {
        }
    }


