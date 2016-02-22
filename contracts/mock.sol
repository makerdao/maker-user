import 'dappsys/token/eth_wrapper.sol';
import 'dappsys/token/base.sol';
import 'dappsys/token/registry.sol';

contract MakerUserMockRegistry is DSTokenRegistry {
    function MakerUserMockRegistry() {
        var mkr = new DSBaseToken(10**18 * 10**6);
        var dai = new DSBaseToken(10**18 * 10**8);
        var eth = new DSEthToken();
        eth.deposit.value(this.balance)();
        _storage["MKR"] = bytes32(address(mkr));
        _storage["DAI"] = bytes32(address(dai));
        _storage["ETH"] = bytes32(address(eth));
    }
}

