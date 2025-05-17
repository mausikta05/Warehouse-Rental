module HelloMessage::WarehouseRental {
    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;
    use aptos_framework::timestamp;

    // Error codes
    const E_NOT_OWNER: u64 = 1;
    const E_ALREADY_RENTED: u64 = 2;
    const E_RENTAL_ACTIVE: u64 = 3;
    const E_INSUFFICIENT_PAYMENT: u64 = 4;

    // Struct representing a warehouse space NFT
    struct WarehouseNFT has key, store {
        space_id: u64,        // Unique identifier for the space
        size: u64,            // Size in square feet
        price_per_day: u64,   // Daily rental price in APT tokens
        is_rented: bool,      // Rental status
        rental_end_time: u64, // When the current rental period ends
        renter: address       // Current renter's address
    }
    
    // Counter for warehouse space IDs
    struct WarehouseCounter has key {
        counter: u64
    }

    // Initialize the warehouse rental system
    public fun initialize(owner: &signer) {
        let counter = WarehouseCounter {
            counter: 0
        };
        move_to(owner, counter);
    }

    // Create a new warehouse space NFT
    public fun create_space(
        owner: &signer, 
        size: u64, 
        price_per_day: u64
    ) acquires WarehouseCounter {
        let owner_addr = signer::address_of(owner);
        
        // Get the next space ID
        let counter = borrow_global_mut<WarehouseCounter>(owner_addr);
        let space_id = counter.counter;
        counter.counter = counter.counter + 1;
        
        // Create the warehouse NFT
        let warehouse = WarehouseNFT {
            space_id,
            size,
            price_per_day,
            is_rented: false,
            rental_end_time: 0,
            renter: @0x0
        };
        
        move_to(owner, warehouse);
    }

    // Rent a warehouse space
    public fun rent_space(
        renter: &signer,
        owner_addr: address,
        space_id: u64,
        days: u64
    ) acquires WarehouseNFT {
        let warehouse = borrow_global_mut<WarehouseNFT>(owner_addr);
        
        // Verify this is the correct space
        assert!(warehouse.space_id == space_id, E_NOT_OWNER);
        
        // Check if the space is available
        assert!(!warehouse.is_rented, E_ALREADY_RENTED);
        
        // Calculate rental cost
        let rental_cost = warehouse.price_per_day * days;
        
        // Transfer payment from renter to owner
        let payment = coin::withdraw<AptosCoin>(renter, rental_cost);
        coin::deposit<AptosCoin>(owner_addr, payment);
        
        // Update warehouse rental information
        warehouse.is_rented = true;
        warehouse.renter = signer::address_of(renter);
        warehouse.rental_end_time = timestamp::now_seconds() + (days * 86400); // days to seconds
    }
}
