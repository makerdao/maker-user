import 'maker/interfaces.sol';

// Contracts for users of the Maker system. If you're looking for
// the source for the Maker system itself, look in maker-core.

// contract MakerUser is MakerUser_V0 {}
contract MakerUser_V0
{
    Maker M;
    address constant MAKER_V0 = 0x0; // TODO

    // Until this modifier is removed from this mixin, you should
    // use it with any function which touches `M`
    modifier maker_sync() {
        _maker_sync();
        _
    }
    function _maker_sync() internal {
        M = M.latest_version();
    }
    // These are utility functions to help you navigate the Maker system.
    // Over time, these will become less expensive or will disappear completely
    // as more features are added directly to Maker.

    function maker_asset( bytes32 symbol )
             maker_sync()
             internal
             constant 
             returns (MakerAsset)
    {
        return M.get_asset( symbol );
    }

    function maker_asset_registry()
             maker_sync()
             internal
             constant
             returns (MakerAssetRegistry)
    {
        return MakerAssetRegistry( address(M.get("MAR")) );
    }

    function MAR() 
             maker_sync()
             internal
             constant
             returns (MakerAssetRegistry)
    {
        return MakerAssetRegistry( address(M.get("MAR")) );
    }

    /* Code generation for internal functions and modifiers:
     *   function sufficient_buffered_balances(...)
     *   function charge(...)
     *   modifier charges(...)
     *   modifier costs(...)
     */

    /*[[[cog
        import cog
        import textwrap

        sufficient_buffer_balances = textwrap.dedent(
        """
            function sufficient_buffer_balances(%(typed_args)s) maker_sync internal returns (bool) {
                var reg = MakerAssetRegistry( address( M.get( "MAR" ) ) );
                %(asset_var_assignments)s
                return %(asset_balance_checks)s;
            }
        """)

        charge = textwrap.dedent(
        """
            function charge(%(typed_args)s) maker_sync() internal returns (bool) {
                var reg = MakerAssetRegistry( address( M.get( "MAR") ) );
                if( sufficient_buffer_balances( %(args)s ) ) {
                    %(asset_charge_calls)s
                    return true;
                }
                return false;
            }
        """)

        modifier_costs = textwrap.dedent(
        """
            modifier costs%(index)s (%(typed_args)s) {
                _maker_sync();

                if( sufficient_buffer_balances(%(args)s) ) {
                     _
                }
            }
        """)
                    
        modifier_charges = textwrap.dedent(
        """
            modifier charges%(index)s (%(typed_args)s) {
                _maker_sync();
                if( charge(%(args)s) ) {
                     _
                }
            }
        """)

        def argline(i):
            s = str(i)
            return "bytes32 symbol%s, uint amount%s" % (s, s)

        def invokeline(i):
            s = str(i)
            return "symbol%s, amount%s" % (s, s)

        for i in range(8):
            asset_balance_checks = []
            asset_var_assignments = ""
            asset_charge_calls = ""

            for j in range(i+1):
                s = str(j+1)
                asset_charge_calls += "\n        reg.get_asset(symbol%s).charge(amount%s);" % (s, s)
                asset_var_assignments += "\n   var asset%s = reg.get_asset(symbol%s);" % (s, s)
                asset_balance_checks.append("asset%s.buffered_balances(address(this)) >= amount%s" % (s, s))

            asset_balance_checks = "\n         && ".join(asset_balance_checks)

            typed_args = ", ".join([(argline(j+1)) for j in range(i+1)])
            args = ", ".join([invokeline(j+1) for j in range(i+1)])

            cog.outl(sufficient_buffer_balances % {
                'typed_args': typed_args,
                'asset_var_assignments': asset_var_assignments,
                'asset_balance_checks': asset_balance_checks
            });

            cog.outl(charge % {
                'typed_args': typed_args,
                'args': args,
                'asset_charge_calls': asset_charge_calls
            });

            cog.outl(modifier_costs % {
                'index': s,
                'typed_args': typed_args,
                'args': args
            })

            cog.outl(modifier_charges % {
                'index': s,
                'typed_args': typed_args,
                'args': args
            })
    ]]]*/

    //[[[end]]]

}

contract MakerMixin is MakerUser_V0 {}
