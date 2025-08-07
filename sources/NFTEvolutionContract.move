module bhupendra_addr::NFTEvolution {
    use aptos_framework::signer;
    use aptos_framework::timestamp;
    use std::string::{Self, String};

    
    struct EvolvingNFT has store, key {
        name: String,
        evolution_level: u64,    
        creation_time: u64,      
        last_interaction: u64,   
        interaction_count: u64,  
    }


    const E_NFT_NOT_FOUND: u64 = 1;
    const E_ALREADY_OWNS_NFT: u64 = 2;

    
    public fun mint_evolving_nft(owner: &signer, name: String) {
        let owner_addr = signer::address_of(owner);
        
       
        assert!(!exists<EvolvingNFT>(owner_addr), E_ALREADY_OWNS_NFT);
        
        let current_time = timestamp::now_seconds();
        
        let nft = EvolvingNFT {
            name,
            evolution_level: 0,
            creation_time: current_time,
            last_interaction: current_time,
            interaction_count: 0,
        };
        
        move_to(owner, nft);
    }

    public fun interact_with_nft(owner: &signer) acquires EvolvingNFT {
        let owner_addr = signer::address_of(owner);
        
        assert!(exists<EvolvingNFT>(owner_addr), E_NFT_NOT_FOUND);
        
        let nft = borrow_global_mut<EvolvingNFT>(owner_addr);
        let current_time = timestamp::now_seconds();
        
        nft.last_interaction = current_time;
        nft.interaction_count = nft.interaction_count + 1;
        
        let time_since_creation = current_time - nft.creation_time;
        let time_factor = time_since_creation / 86400; // Days since creation
        let interaction_factor = nft.interaction_count / 5; // Every 5 interactions
        
        let new_level = time_factor + interaction_factor;
        if (new_level > nft.evolution_level) {
            nft.evolution_level = new_level;
        };
    }
}
