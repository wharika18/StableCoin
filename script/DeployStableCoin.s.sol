// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {StableCoin} from "../src/StableCoin.sol";
import {Engine} from "../src/Engine.sol";

contract DeployStableCoin is Script {
    address[] public tokenAddresses;
    address[] public priceFeedAddresses;

    function run() external returns (StableCoin, Engine, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();

        (
            address wethUsdPriceFeed,
            address wbtcUsdPriceFeed,
            address weth,
            address wbtc,
            uint256 deployerKey
        ) = helperConfig.activeNetworkConfig();
        tokenAddresses = [weth, wbtc];
        priceFeedAddresses = [wethUsdPriceFeed, wbtcUsdPriceFeed];

        vm.startBroadcast(deployerKey);
        StableCoin scoin = new StableCoin();
        Engine engine = new Engine(
            tokenAddresses,
            priceFeedAddresses,
            address(scoin)
        );
        scoin.transferOwnership(address(engine));
        vm.stopBroadcast();
        return (scoin, engine, helperConfig);
    }
}
