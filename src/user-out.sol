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
        var reg = MakerAssetRegistry( address(M.get("MAR")) );
        return reg.get_asset(symbol);
    }

    function maker_asset_registry()
             maker_sync()
             internal
             constant
             returns (MakerAssetRegistry)
    {
        return MakerAssetRegistry( address(M.get("MAR")) );
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


            cog.outl("function sufficient_balances(%s) maker_sync() internal returns (bool)" % (typed_args))
            cog.outl("{")
            cog.outl("    var reg = MakerAssetRegistry( address(M.get(\"MAR\")) );")
            conditions = []
            for j in range(i+1):
                s = str(j+1)
                cog.outl("    var asset%s = reg.get_asset(symbol%s);" % (s,s))
                conditions.append("asset%s.buffered_balances(address(this)) >= amount%s" % (s, s))
            conditions = "\n         && ".join(conditions)
            cog.outl("    return %s;" % conditions);
            cog.outl("}")


            cog.outl("function charge(%s) maker_sync() internal returns (bool)" % (typed_args))
            cog.outl("{")
            cog.outl("    var reg = MakerAssetRegistry( address(M.get(\"MAR\")) );")
            cog.outl("    if( sufficient_balances( %s ) )" % args)
            cog.outl("    {")
            for j in range(i+1):
                s = str(j+1)
                cog.outl("        var asset%s = reg.get_asset(symbol%s);" % (s,s))
                cog.outl("        asset%s.charge(amount%s);" % (s, s))
            cog.outl("        return true;")
            cog.outl("    }")
            cog.outl("    return false;")
            cog.outl("}")


            cog.outl("modifier costs%s(%s) {" % (s, typed_args))
            cog.outl("    _maker_sync();")
            cog.outl("    if( sufficient_balances(%s) ) {" % (args))
            cog.outl("         _")
            cog.outl("    }")
            cog.outl("}")

            cog.outl("modifier charges%s(%s) {" % (s, typed_args))
            cog.outl("    _maker_sync();")
            cog.outl("    if( charge(%s) ) {" % (args))
            cog.outl("         _")
            cog.outl("    }")
            cog.outl("}")
    ]]]*/
    function sufficient_balances(bytes32 symbol1, uint amount1) maker_sync() internal returns (bool)
    {
        var reg = MakerAssetRegistry( address(M.get("MAR")) );
        var asset1 = reg.get_asset(symbol1);
        return asset1.buffered_balance() >= amount1;
    }
    function charge(bytes32 symbol1, uint amount1) maker_sync() internal returns (bool)
    {
        var reg = MakerAssetRegistry( address(M.get("MAR")) );
        if( sufficient_balances( symbol1, amount1 ) )
        {
            var asset1 = reg.get_asset(symbol1);
            asset1.charge(amount1);
            return true;
        }
        return false;
    }
    modifier costs1(bytes32 symbol1, uint amount1) {
        _maker_sync();
        if( sufficient_balances(symbol1, amount1) ) {
             _
        }
    }
    modifier charges1(bytes32 symbol1, uint amount1) {
        _maker_sync();
        if( charge(symbol1, amount1) ) {
             _
        }
    }
    function sufficient_balances(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2) maker_sync() internal returns (bool)
    {
        var reg = MakerAssetRegistry( address(M.get("MAR")) );
        var asset1 = reg.get_asset(symbol1);
        var asset2 = reg.get_asset(symbol2);
        return asset1.buffered_balance() >= amount1
             && asset2.buffered_balance() >= amount2;
    }
    function charge(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2) maker_sync() internal returns (bool)
    {
        var reg = MakerAssetRegistry( address(M.get("MAR")) );
        if( sufficient_balances( symbol1, amount1, symbol2, amount2 ) )
        {
            var asset1 = reg.get_asset(symbol1);
            asset1.charge(amount1);
            var asset2 = reg.get_asset(symbol2);
            asset2.charge(amount2);
            return true;
        }
        return false;
    }
    modifier costs2(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2) {
        _maker_sync();
        if( sufficient_balances(symbol1, amount1, symbol2, amount2) ) {
             _
        }
    }
    modifier charges2(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2) {
        _maker_sync();
        if( charge(symbol1, amount1, symbol2, amount2) ) {
             _
        }
    }
    function sufficient_balances(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2, bytes32 symbol3, uint amount3) maker_sync() internal returns (bool)
    {
        var reg = MakerAssetRegistry( address(M.get("MAR")) );
        var asset1 = reg.get_asset(symbol1);
        var asset2 = reg.get_asset(symbol2);
        var asset3 = reg.get_asset(symbol3);
        return asset1.buffered_balance() >= amount1
             && asset2.buffered_balance() >= amount2
             && asset3.buffered_balance() >= amount3;
    }
    function charge(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2, bytes32 symbol3, uint amount3) maker_sync() internal returns (bool)
    {
        var reg = MakerAssetRegistry( address(M.get("MAR")) );
        if( sufficient_balances( symbol1, amount1, symbol2, amount2, symbol3, amount3 ) )
        {
            var asset1 = reg.get_asset(symbol1);
            asset1.charge(amount1);
            var asset2 = reg.get_asset(symbol2);
            asset2.charge(amount2);
            var asset3 = reg.get_asset(symbol3);
            asset3.charge(amount3);
            return true;
        }
        return false;
    }
    modifier costs3(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2, bytes32 symbol3, uint amount3) {
        _maker_sync();
        if( sufficient_balances(symbol1, amount1, symbol2, amount2, symbol3, amount3) ) {
             _
        }
    }
    modifier charges3(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2, bytes32 symbol3, uint amount3) {
        _maker_sync();
        if( charge(symbol1, amount1, symbol2, amount2, symbol3, amount3) ) {
             _
        }
    }
    function sufficient_balances(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2, bytes32 symbol3, uint amount3, bytes32 symbol4, uint amount4) maker_sync() internal returns (bool)
    {
        var reg = MakerAssetRegistry( address(M.get("MAR")) );
        var asset1 = reg.get_asset(symbol1);
        var asset2 = reg.get_asset(symbol2);
        var asset3 = reg.get_asset(symbol3);
        var asset4 = reg.get_asset(symbol4);
        return asset1.buffered_balance() >= amount1
             && asset2.buffered_balance() >= amount2
             && asset3.buffered_balance() >= amount3
             && asset4.buffered_balance() >= amount4;
    }
    function charge(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2, bytes32 symbol3, uint amount3, bytes32 symbol4, uint amount4) maker_sync() internal returns (bool)
    {
        var reg = MakerAssetRegistry( address(M.get("MAR")) );
        if( sufficient_balances( symbol1, amount1, symbol2, amount2, symbol3, amount3, symbol4, amount4 ) )
        {
            var asset1 = reg.get_asset(symbol1);
            asset1.charge(amount1);
            var asset2 = reg.get_asset(symbol2);
            asset2.charge(amount2);
            var asset3 = reg.get_asset(symbol3);
            asset3.charge(amount3);
            var asset4 = reg.get_asset(symbol4);
            asset4.charge(amount4);
            return true;
        }
        return false;
    }
    modifier costs4(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2, bytes32 symbol3, uint amount3, bytes32 symbol4, uint amount4) {
        _maker_sync();
        if( sufficient_balances(symbol1, amount1, symbol2, amount2, symbol3, amount3, symbol4, amount4) ) {
             _
        }
    }
    modifier charges4(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2, bytes32 symbol3, uint amount3, bytes32 symbol4, uint amount4) {
        _maker_sync();
        if( charge(symbol1, amount1, symbol2, amount2, symbol3, amount3, symbol4, amount4) ) {
             _
        }
    }
    function sufficient_balances(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2, bytes32 symbol3, uint amount3, bytes32 symbol4, uint amount4, bytes32 symbol5, uint amount5) maker_sync() internal returns (bool)
    {
        var reg = MakerAssetRegistry( address(M.get("MAR")) );
        var asset1 = reg.get_asset(symbol1);
        var asset2 = reg.get_asset(symbol2);
        var asset3 = reg.get_asset(symbol3);
        var asset4 = reg.get_asset(symbol4);
        var asset5 = reg.get_asset(symbol5);
        return asset1.buffered_balance() >= amount1
             && asset2.buffered_balance() >= amount2
             && asset3.buffered_balance() >= amount3
             && asset4.buffered_balance() >= amount4
             && asset5.buffered_balance() >= amount5;
    }
    function charge(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2, bytes32 symbol3, uint amount3, bytes32 symbol4, uint amount4, bytes32 symbol5, uint amount5) maker_sync() internal returns (bool)
    {
        var reg = MakerAssetRegistry( address(M.get("MAR")) );
        if( sufficient_balances( symbol1, amount1, symbol2, amount2, symbol3, amount3, symbol4, amount4, symbol5, amount5 ) )
        {
            var asset1 = reg.get_asset(symbol1);
            asset1.charge(amount1);
            var asset2 = reg.get_asset(symbol2);
            asset2.charge(amount2);
            var asset3 = reg.get_asset(symbol3);
            asset3.charge(amount3);
            var asset4 = reg.get_asset(symbol4);
            asset4.charge(amount4);
            var asset5 = reg.get_asset(symbol5);
            asset5.charge(amount5);
            return true;
        }
        return false;
    }
    modifier costs5(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2, bytes32 symbol3, uint amount3, bytes32 symbol4, uint amount4, bytes32 symbol5, uint amount5) {
        _maker_sync();
        if( sufficient_balances(symbol1, amount1, symbol2, amount2, symbol3, amount3, symbol4, amount4, symbol5, amount5) ) {
             _
        }
    }
    modifier charges5(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2, bytes32 symbol3, uint amount3, bytes32 symbol4, uint amount4, bytes32 symbol5, uint amount5) {
        _maker_sync();
        if( charge(symbol1, amount1, symbol2, amount2, symbol3, amount3, symbol4, amount4, symbol5, amount5) ) {
             _
        }
    }
    function sufficient_balances(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2, bytes32 symbol3, uint amount3, bytes32 symbol4, uint amount4, bytes32 symbol5, uint amount5, bytes32 symbol6, uint amount6) maker_sync() internal returns (bool)
    {
        var reg = MakerAssetRegistry( address(M.get("MAR")) );
        var asset1 = reg.get_asset(symbol1);
        var asset2 = reg.get_asset(symbol2);
        var asset3 = reg.get_asset(symbol3);
        var asset4 = reg.get_asset(symbol4);
        var asset5 = reg.get_asset(symbol5);
        var asset6 = reg.get_asset(symbol6);
        return asset1.buffered_balance() >= amount1
             && asset2.buffered_balance() >= amount2
             && asset3.buffered_balance() >= amount3
             && asset4.buffered_balance() >= amount4
             && asset5.buffered_balance() >= amount5
             && asset6.buffered_balance() >= amount6;
    }
    function charge(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2, bytes32 symbol3, uint amount3, bytes32 symbol4, uint amount4, bytes32 symbol5, uint amount5, bytes32 symbol6, uint amount6) maker_sync() internal returns (bool)
    {
        var reg = MakerAssetRegistry( address(M.get("MAR")) );
        if( sufficient_balances( symbol1, amount1, symbol2, amount2, symbol3, amount3, symbol4, amount4, symbol5, amount5, symbol6, amount6 ) )
        {
            var asset1 = reg.get_asset(symbol1);
            asset1.charge(amount1);
            var asset2 = reg.get_asset(symbol2);
            asset2.charge(amount2);
            var asset3 = reg.get_asset(symbol3);
            asset3.charge(amount3);
            var asset4 = reg.get_asset(symbol4);
            asset4.charge(amount4);
            var asset5 = reg.get_asset(symbol5);
            asset5.charge(amount5);
            var asset6 = reg.get_asset(symbol6);
            asset6.charge(amount6);
            return true;
        }
        return false;
    }
    modifier costs6(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2, bytes32 symbol3, uint amount3, bytes32 symbol4, uint amount4, bytes32 symbol5, uint amount5, bytes32 symbol6, uint amount6) {
        _maker_sync();
        if( sufficient_balances(symbol1, amount1, symbol2, amount2, symbol3, amount3, symbol4, amount4, symbol5, amount5, symbol6, amount6) ) {
             _
        }
    }
    modifier charges6(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2, bytes32 symbol3, uint amount3, bytes32 symbol4, uint amount4, bytes32 symbol5, uint amount5, bytes32 symbol6, uint amount6) {
        _maker_sync();
        if( charge(symbol1, amount1, symbol2, amount2, symbol3, amount3, symbol4, amount4, symbol5, amount5, symbol6, amount6) ) {
             _
        }
    }
    function sufficient_balances(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2, bytes32 symbol3, uint amount3, bytes32 symbol4, uint amount4, bytes32 symbol5, uint amount5, bytes32 symbol6, uint amount6, bytes32 symbol7, uint amount7) maker_sync() internal returns (bool)
    {
        var reg = MakerAssetRegistry( address(M.get("MAR")) );
        var asset1 = reg.get_asset(symbol1);
        var asset2 = reg.get_asset(symbol2);
        var asset3 = reg.get_asset(symbol3);
        var asset4 = reg.get_asset(symbol4);
        var asset5 = reg.get_asset(symbol5);
        var asset6 = reg.get_asset(symbol6);
        var asset7 = reg.get_asset(symbol7);
        return asset1.buffered_balance() >= amount1
             && asset2.buffered_balance() >= amount2
             && asset3.buffered_balance() >= amount3
             && asset4.buffered_balance() >= amount4
             && asset5.buffered_balance() >= amount5
             && asset6.buffered_balance() >= amount6
             && asset7.buffered_balance() >= amount7;
    }
    function charge(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2, bytes32 symbol3, uint amount3, bytes32 symbol4, uint amount4, bytes32 symbol5, uint amount5, bytes32 symbol6, uint amount6, bytes32 symbol7, uint amount7) maker_sync() internal returns (bool)
    {
        var reg = MakerAssetRegistry( address(M.get("MAR")) );
        if( sufficient_balances( symbol1, amount1, symbol2, amount2, symbol3, amount3, symbol4, amount4, symbol5, amount5, symbol6, amount6, symbol7, amount7 ) )
        {
            var asset1 = reg.get_asset(symbol1);
            asset1.charge(amount1);
            var asset2 = reg.get_asset(symbol2);
            asset2.charge(amount2);
            var asset3 = reg.get_asset(symbol3);
            asset3.charge(amount3);
            var asset4 = reg.get_asset(symbol4);
            asset4.charge(amount4);
            var asset5 = reg.get_asset(symbol5);
            asset5.charge(amount5);
            var asset6 = reg.get_asset(symbol6);
            asset6.charge(amount6);
            var asset7 = reg.get_asset(symbol7);
            asset7.charge(amount7);
            return true;
        }
        return false;
    }
    modifier costs7(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2, bytes32 symbol3, uint amount3, bytes32 symbol4, uint amount4, bytes32 symbol5, uint amount5, bytes32 symbol6, uint amount6, bytes32 symbol7, uint amount7) {
        _maker_sync();
        if( sufficient_balances(symbol1, amount1, symbol2, amount2, symbol3, amount3, symbol4, amount4, symbol5, amount5, symbol6, amount6, symbol7, amount7) ) {
             _
        }
    }
    modifier charges7(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2, bytes32 symbol3, uint amount3, bytes32 symbol4, uint amount4, bytes32 symbol5, uint amount5, bytes32 symbol6, uint amount6, bytes32 symbol7, uint amount7) {
        _maker_sync();
        if( charge(symbol1, amount1, symbol2, amount2, symbol3, amount3, symbol4, amount4, symbol5, amount5, symbol6, amount6, symbol7, amount7) ) {
             _
        }
    }
    function sufficient_balances(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2, bytes32 symbol3, uint amount3, bytes32 symbol4, uint amount4, bytes32 symbol5, uint amount5, bytes32 symbol6, uint amount6, bytes32 symbol7, uint amount7, bytes32 symbol8, uint amount8) maker_sync() internal returns (bool)
    {
        var reg = MakerAssetRegistry( address(M.get("MAR")) );
        var asset1 = reg.get_asset(symbol1);
        var asset2 = reg.get_asset(symbol2);
        var asset3 = reg.get_asset(symbol3);
        var asset4 = reg.get_asset(symbol4);
        var asset5 = reg.get_asset(symbol5);
        var asset6 = reg.get_asset(symbol6);
        var asset7 = reg.get_asset(symbol7);
        var asset8 = reg.get_asset(symbol8);
        return asset1.buffered_balance() >= amount1
             && asset2.buffered_balance() >= amount2
             && asset3.buffered_balance() >= amount3
             && asset4.buffered_balance() >= amount4
             && asset5.buffered_balance() >= amount5
             && asset6.buffered_balance() >= amount6
             && asset7.buffered_balance() >= amount7
             && asset8.buffered_balance() >= amount8;
    }
    function charge(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2, bytes32 symbol3, uint amount3, bytes32 symbol4, uint amount4, bytes32 symbol5, uint amount5, bytes32 symbol6, uint amount6, bytes32 symbol7, uint amount7, bytes32 symbol8, uint amount8) maker_sync() internal returns (bool)
    {
        var reg = MakerAssetRegistry( address(M.get("MAR")) );
        if( sufficient_balances( symbol1, amount1, symbol2, amount2, symbol3, amount3, symbol4, amount4, symbol5, amount5, symbol6, amount6, symbol7, amount7, symbol8, amount8 ) )
        {
            var asset1 = reg.get_asset(symbol1);
            asset1.charge(amount1);
            var asset2 = reg.get_asset(symbol2);
            asset2.charge(amount2);
            var asset3 = reg.get_asset(symbol3);
            asset3.charge(amount3);
            var asset4 = reg.get_asset(symbol4);
            asset4.charge(amount4);
            var asset5 = reg.get_asset(symbol5);
            asset5.charge(amount5);
            var asset6 = reg.get_asset(symbol6);
            asset6.charge(amount6);
            var asset7 = reg.get_asset(symbol7);
            asset7.charge(amount7);
            var asset8 = reg.get_asset(symbol8);
            asset8.charge(amount8);
            return true;
        }
        return false;
    }
    modifier costs8(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2, bytes32 symbol3, uint amount3, bytes32 symbol4, uint amount4, bytes32 symbol5, uint amount5, bytes32 symbol6, uint amount6, bytes32 symbol7, uint amount7, bytes32 symbol8, uint amount8) {
        _maker_sync();
        if( sufficient_balances(symbol1, amount1, symbol2, amount2, symbol3, amount3, symbol4, amount4, symbol5, amount5, symbol6, amount6, symbol7, amount7, symbol8, amount8) ) {
             _
        }
    }
    modifier charges8(bytes32 symbol1, uint amount1, bytes32 symbol2, uint amount2, bytes32 symbol3, uint amount3, bytes32 symbol4, uint amount4, bytes32 symbol5, uint amount5, bytes32 symbol6, uint amount6, bytes32 symbol7, uint amount7, bytes32 symbol8, uint amount8) {
        _maker_sync();
        if( charge(symbol1, amount1, symbol2, amount2, symbol3, amount3, symbol4, amount4, symbol5, amount5, symbol6, amount6, symbol7, amount7, symbol8, amount8) ) {
             _
        }
    }
    //[[[end]]]

}

contract MakerUser is MakerUser_V0 {}
