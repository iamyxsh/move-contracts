module dextr_test::UserRegistry {
  use std::signer;

  const EALREADY_REGISTERED: u64 = 1;
  const ENOT_REGISTERED: u64 = 2;

  const KYC_NOTAPPLIED: u8 = 1;
  const KYC_APPLIED: u8 = 2;
  const KYC_APPROVED: u8 = 3;
  const KYC_REJECTED: u8 = 4;

  struct UserRegistry has key {
    is_registered: bool,
    kyc_status: u8,
  }

  public fun register_user(account: &signer) {
    let signer_address = signer::address_of(account);
    assert!(!exists<UserRegistry>(signer_address), EALREADY_REGISTERED);

    let registry = UserRegistry {
      is_registered: true,
      kyc_status: KYC_NOTAPPLIED,
    };

    move_to(account, registry);
  }


  #[view]
  public fun is_registered(addr: address): bool acquires UserRegistry {
    borrow_global<UserRegistry>(addr).is_registered
  }


  #[test(user = @0x123)]
    public entry fun test_end_to_end(
        user: signer
    ) acquires UserRegistry {
       let signer_address = signer::address_of(&user);

      register_user(&user);

      let user_registered = is_registered(signer_address);

      assert!(user_registered, 0);
    }
}