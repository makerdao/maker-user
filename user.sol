import 'dappsys/math/math.sol';
import 'maker/interfaces.sol';

// Contracts for users of the Maker system. If you're looking for
// the source for the Maker system itself, look in maker-core.

contract MakerAssetMathUser is DSFixedPointMathUser(10**18) {}
// contract MakerUser is MakerUser_V0 {}     below definition
contract MakerUser_V0 is DSTransientContractConsumer
{
    Maker M;
    // Until this modifier is removed from this mixin, you should
    // use it with any function which touches `M`
    modifier maker_sync() {
        _ds_sync();
        M = Maker(address(t));
        _
    }

    // These are utility functions to help you navigate the Maker system.
    // Over time, these will become less expensive or will disappear completely
    // as more features are added directly to Maker.
    function asset( bytes32 symbol )
             maker_sync()
             internal
             returns (MakerAsset)
    {
        var reg = MakerAssetRegistry( M.get("MAR") );
        return reg.get_asset(symbol);
    }


    /* Code generation for charge(...) internal function and costs(...) modifier
     */

    /*[[[cog
        import cog
        def argline(i):
            s = str(i)
            return "bytes32 symbol%s, uint amount%s" % (s, s)
        def invokeline(i):
            s = str(i)
            return "symbol%s, amount%s" % (s, s)

        for i in range(8):
            s = str(i+1)
            typed_args = ", ".join([(argline(j+1)) for j in range(i+1)])
            args = ", ".join([invokeline(j+1) for j in range(i+1)])


            cog.outl("function charge(%s) internal returns (bool)" % (typed_args))
            cog.outl("{")
            cog.outl("    var reg = MakerAssetRegistry( address(M.get(\"MAR\")) );")
            conditions = []
            for j in range(i+1):
                s = str(j+1)
                cog.outl("    var asset%s = reg.get_asset(symbol%s);" % (s,s))
                conditions.append("asset%s.buffered_balance() >= amount%s" % (s, s))
            conditions = "\n         && ".join(conditions)
            cog.outl("    if( %s )" % conditions)
            cog.outl("    {")
            for j in range(i+1):
                s = str(j+1)
                cog.outl("        asset%s.charge(amount%s);" % (s, s))
            cog.outl("        return true;")
            cog.outl("    }")
            cog.outl("    return false;")
            cog.outl("}")



            cog.outl("modifier costs%s(%s) {" % (s, typed_args))
            cog.outl("    if( charge(%s) ) {" % (args))
            cog.outl("         _")
            cog.outl("    }")
            cog.outl("}")
    ]]]*/

    //[[[end]]]

}

contract MakerUser is MakerUser_V0 {}
