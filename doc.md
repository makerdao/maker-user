Introducing MA*:  Maker Asset (Platform|Registry|Interface|Controllers)


Maker's ultimate goal is the deployment and widespread adoption of the Dai stablecoin and credit system.

The Maker contract system interacts with multiple assets on the Ethereum blockchain.

To do this, it wraps them in contracts which make them easier to manipulate programmatically.



Using assets in the Maker ecosystem is easy, in part because of the `MakerUser` mixin.
A mixin is what I call a contract with only internal functions - it is not an abstract contract (an interface),
but the compiler will only emit anything if you use one of the internal functions in a derived contract. It is like a package of helper functions.

Follow the installation guide until you are able to compile/run these .sol/.js files, respectively.

`example.sol`:
    
    import 'maker/user.sol';

    contract Example is MakerUser {
    }

`example.js`:

    var maker = require("maker")(web3);


Assets are stored in the Maker Asset Registry. Accessing the registry is easy:

`example.sol`:
    
    import 'maker/user.sol';

    contract Example is MakerUser {
        function example() {
            MakerAssetRegistry reg = MAR(); // == asset_registry()
        }
    }


`example.js`

    var maker = require("maker")(web3);
    var registry = maker.MAR();


Things to note:
    * Everything inside MakerUser is an internal function. This means it isn't exposed
      as an entrypoint, and it also isn't compiled into the contract unless you actually
      use it.
    * Try not to save address references. The only fixed addresses in the Maker system which you
      need to interact with
      are already hard-coded in the `MakerUser` mixin. You should always be using helper functions
      unless you really know what you are doing. Efficiency is a long-term goal and generally
      each new release of `MakerUser` (and every other component of Maker) will add less and
      less overhead. However, for now we are prioritizing correctness and code simplicity over
      efficiency. If you plan on deploying a very long-running contract soon and want to learn how to
      safely cut corners, you should contact the Maker core dev team for help.


Once you have the registry, you can get assets by symbol. You can also just use a built-in helper.

`example.sol`:
    
    import 'maker/user.sol';

    contract Example is MakerUser {
        function example() {
            MakerAssetRegistry reg = MAR(); // == asset_registry()
            MakerAsset ETH = reg.get_asset("ETH") // from (local to trx!) registry reference
            MakerAsset MKR = maker_asset("MKR") // from helper
        }
    }


`example.js`

    var maker = require("maker")(web3);
    var reg = maker.MAR();
    var ETH = reg.get_asset("ETH");
    var MKR = maker.maker_asset


Now we can finally learn to use the contract interface. The `.sol` and `.js` examples are going to diverge, because
the intended usage is different for contracts and for keys.

Let's start with the contract example. I'll rewrite the example to be a basic
OTC sell contract, which must be created by someone deliberately spending ETH,
then filled by someone with MKR who wants to trade.


`example.sol`:
    
    import 'maker/user.sol';

    contract SimpleOTC is MakerUser {
        address creator;
        function SimpleOTC() {
            creator = msg.sender;
            var ETH = maker_asset("ETH");
            if( ! ETH.charge(1000) ) { // whoever instantiated this didn't have enough ETH
                suicide(msg.sender);
            }
            // This address now has 1000 ETH
        }
        function fill() {
            var MKR = maker_asset("MKR");
            var ETH = maker_asset("ETH");
            if( MKR.charge(500) ) {
                MKR.transfer(creator, 500);
                ETH.withdraw(1000);
                suicide(msg.sender);
            }
        }
    }

To use this contract, you need to have enough MKR in your buffer. There are two ways to
do this, one is slightly more usable for contracts and the other can only be used by keys.

`otc_buyer.sol`

    contract otc_buyer() is MakerUser {
        function otc_buyer() {
            var otc = SimpleOTC(0xdeadbeef);
            maker_asset("MKR").withdraw(500);
            otc.fill();
        }
    }

If you are a key, you can use the same function, but it's not convenient, and it is only
atomic within your key's "session" (other transactions signed by the same key share the same
buffer):


    var otc = SimpleOTC.at(0xdeadbeef)
    maker.get_asset("MKR").withdraw(500);
    // wait...
    otc.fill();

Instead, you can use the `withdraw_and_call` function. This function does a withdrawal
and then calls the target directly from the asset contract. This function is restricted
to keys (you cannot call it from a contract). This has the nice side-effect of allowing
the target to still check if the signer is the balance owner, by checking if the sender
is the asset contract.


    var otc = SimpleOTC.at(0xdeadbeef)
    maker.get_asset("MKR").withdraw_and_call(500, otc.address, sig("fill()"));
                     //   .withdraw_and_call(500, otc.fill)    soon this will be possible

