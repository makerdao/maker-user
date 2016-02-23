import 'interfaces.sol';
import 'generic.sol';

contract MakerUser is MakerUserGeneric {
    // TODO ensure synced with dappfile until we can use constant macro
    function MakerUser( MakerUserLinkType registry )
             MakerUserGeneric( MakerTokenRegistry(registry) )
    {
        if( address(registry) == address(0x0) ) {
            // reg = MakerTokenRegistry(0x1111);
            throw;
        } else if( address(registry) == address(0x1) ) {
            registry = MakerTokenRegistry(0x213183be469a38e99facc2c468bb7e3c01377bce);
        } else {
            registry = MakerTokenRegistry(registry);
        }
    }
}
contract MakerUserMainnet is MakerUser(MakerUserLinkType(0x0)) {}
contract MakerUserMorden is MakerUser(MakerUserLinkType(0x1)) {}
