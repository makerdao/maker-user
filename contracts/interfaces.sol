import 'dappsys/token/erc20.sol';
import 'dappsys/token/registry.sol';

// A magic type which is either a MakerTokenRegistry or a flag indicating
// the network whose singleton to use (0 for mainnet, 1 for morden).
contract MakerUserLinkType {}

// Maker's curated DSTokenRegistry
// ethereum:
// morden: 0x1 -> 0x213183be469a38e99facc2c468bb7e3c01377bce
contract MakerTokenRegistry is DSTokenRegistry, MakerUserLinkType {}
contract MakerAssetRegistry is DSTokenRegistry, MakerUserLinkType {}


