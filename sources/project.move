module MyModule::ReferralProgram {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a referrer and their earned tokens.
    struct Referrer has store, key {
        total_tokens: u64,  // Total tokens earned by the referrer
    }

    /// Function to register a new referrer.
    public fun register_referrer(initiator: &signer, referrer_address: address) {
        let referrer = Referrer {
            total_tokens: 0,  // Start with 0 tokens
        };
        move_to(initiator, referrer);
    }

    /// Function to reward tokens to a referrer for successful referrals.
    public fun reward_referrer(initiator: &signer, referrer_address: address, tokens: u64) acquires Referrer {
        let referrer = borrow_global_mut<Referrer>(referrer_address);

        // Transfer tokens from the initiator to the referrer
        let reward = coin::withdraw<AptosCoin>(initiator, tokens);
        coin::deposit<AptosCoin>(referrer_address, reward);

        // Update the referrer's total tokens
        referrer.total_tokens = referrer.total_tokens + tokens;
    }
}
