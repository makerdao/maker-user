import 'interfaces.sol';
import 'dappsys/token/token.sol';

contract MakerUserGeneric {
    MakerTokenRegistry _maker_tokens;

    // `registry` MUST throw for invalid `getToken` calls (unset tokens).
    // Use a registry derived from `DSNullMap`, for example.
    // Tokens contracts must not return true on failure!
    function MakerUserGeneric( MakerTokenRegistry registry ) {
        _maker_tokens = registry;
    }

    function getToken(bytes32 symbol) internal constant returns (DSToken t) {
        return _maker_tokens.getToken(symbol);
    }
    function totalSupply(bytes32 symbol) internal constant returns (uint supply) {
        return getToken(symbol).totalSupply();
    }
    function balanceOf( address who, bytes32 symbol ) internal constant returns (uint value) {
        return getToken(symbol).balanceOf(who);
    }
    function allowance( address owner
                      , address spender
                      , bytes32 symbol)
        internal
        constant
        returns (uint _allowance)
    {
        return getToken(symbol).allowance(owner, spender);
    }
    function transfer( address to, uint value, bytes32 symbol) internal returns (bool ok)
    {
        var success = getToken(symbol).transfer(to, value);
        if( !success ) throw;
        return success;
    }
    function transferFrom( address from, address to, uint value, bytes32 symbol)
        internal 
        returns (bool ok)
    {
        var success = getToken(symbol).transferFrom(from, to, value);
        if( !success ) throw;
        return success;
    }
    function approve(address spender, uint value, bytes32 symbol) internal returns (bool ok)
    {
        var success = getToken(symbol).approve(spender, value);
        if( !success ) throw;
        return success;
    }

    modifier costs( uint amount, bytes32 symbol )
    {
        if( transferFrom(msg.sender, this, amount, symbol) ) {
            _
        } else {
            throw;
        }
    }
    // @dev Self-destructs if there is no throw or return. Put this FIRST in your chain of modifiers.
    // Roll your own access control to use this (e.g. `owned` or `DSAuth`)
    modifier selfdestructs() {
        _
        selfdestruct(msg.sender);
    }
}

contract MakerUserMorden is MakerUserGeneric(MakerTokenRegistry(0x0)) {}
contract MakerUser is MakerUserGeneric(MakerTokenRegistry(0x0)) {}
