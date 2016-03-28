import 'interfaces.sol';
import 'generic.sol';

contract MakerUser is MakerUserGeneric {
    // TODO ensure synced with dappfile until we can use constant macro
    function MakerUser( MakerUserLinkType registry )
             MakerUserGeneric( MakerTokenRegistry(registry) )
    {
        if( address(registry) == address(0x0) ) {  // mainnet
            registry = MakerTokenRegistry(0xc6882fbffd309dc976dd6e4c79cc91e4c1482140);
        } else if( address(registry) == address(0x1) ) { // morden
            registry = MakerTokenRegistry(0x877c5369c747d24d9023c88c1aed1724f1993efe);
        } else {
            registry = MakerTokenRegistry(registry);
        }
    }
}
contract MakerUserMainnet is MakerUser(MakerUserLinkType(0x0)) {}
contract MakerUserMorden is MakerUser(MakerUserLinkType(0x1)) {}
