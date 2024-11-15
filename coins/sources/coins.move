module dextr_test::coins {
    use std::signer;
    use std::string::utf8;
    use supra_framework::coin;

    struct USDC {}

    struct WBTC {}

    struct WETH {}

    struct DXTR {}

    struct Caps<phantom CoinType> has key {
        mint: coin::MintCapability<CoinType>,
        freeze: coin::FreezeCapability<CoinType>,
        burn: coin::BurnCapability<CoinType>,

    }

    public entry fun register_coins(token_admin: &signer) {
        let (btc_b, btc_f, btc_m) =
            coin::initialize<WBTC>(token_admin,
                utf8(b"Wrapped Bitcoin"), utf8(b"BTC"), 6, true);
        let (eth_b, eth_f, eth_m) =
            coin::initialize<WETH>(token_admin,
                utf8(b"Wrapped Ethereum"), utf8(b"ETH"), 6, true);
        let (usdc_b, usdc_f, usdc_m) =
            coin::initialize<USDC>(token_admin,
                utf8(b"USD Coin"), utf8(b"USDC"), 6, true);
        let (dextr_b, dextr_f, dextr_m) =
            coin::initialize<DXTR>(token_admin,
                utf8(b"Dextr"), utf8(b"DXTR"), 6, true);

        coin::register<WBTC>(token_admin);
        coin::register<WETH>(token_admin);
        coin::register<USDC>(token_admin);
        coin::register<DXTR>(token_admin);

        move_to(token_admin, Caps<WETH> { mint: eth_m, burn: eth_b, freeze: eth_f });
        move_to(token_admin, Caps<USDC> { mint: usdc_m, burn: usdc_b, freeze: usdc_f });
        move_to(token_admin, Caps<WBTC> { mint: btc_m, burn: btc_b, freeze: btc_f });
        move_to(token_admin, Caps<DXTR> { mint: dextr_m, burn: dextr_b, freeze: dextr_f });
    }

    public entry fun mint_coin<CoinType>(token_admin: &signer,acc_addr: address, amount: u64) acquires Caps {
        let account_addr= signer::address_of(token_admin);
        ensure_coin_store<CoinType>(token_admin);
        let caps = borrow_global<Caps<CoinType>>(account_addr);
        let coins = coin::mint<CoinType>(amount, &caps.mint);
        coin::deposit(acc_addr, coins);
    }

    // ------------------ Private Functions -----------------------//

    fun ensure_coin_store<CoinType>(account: &signer) {
        let account_addr = signer::address_of(account);

        if (!coin::is_account_registered<CoinType>(account_addr)) {
            coin::register<CoinType>(account);
        };
    }

}