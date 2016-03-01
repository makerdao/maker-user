import 'interfaces.sol';
import 'generic.sol';

contract MakerUser is MakerUserGeneric {
    // TODO ensure synced with dappfile until we can use constant macro
    function MakerUser( MakerUserLinkType registry )
             MakerUserGeneric( MakerTokenRegistry(registry) )
    {
        if( address(registry) == address(0x0) ) {
            registry = MakerTokenRegistry(0x37d3e484971a2463eef75b684ca3e17c93128884);
        } else if( address(registry) == address(0x1) ) {
            registry = MakerTokenRegistry(0x213183be469a38e99facc2c468bb7e3c01377bce);
        } else {
            registry = MakerTokenRegistry(registry);
        }
    }
}
contract MakerUserMainnet is MakerUser(MakerUserLinkType(0x0)) {}
contract MakerUserMorden is MakerUser(MakerUserLinkType(0x1)) {}
