Overview
WarehouseRental is a Move module on the Aptos blockchain that enables the creation, management, and rental of warehouse spaces represented as NFTs. Each space can be listed with a specific size and rental price, and users can pay with APT tokens to rent the spaces for a defined period.

🧩 Features
✅ Initialize the warehouse rental system

🏗️ Create warehouse spaces as NFTs with unique IDs

💸 Rent available spaces using APT tokens

🕒 Track rental periods with timestamps

🔐 Secure ownership and rental logic

🔧 Module Structure
Structs
WarehouseNFT: Represents a warehouse space.

space_id: Unique ID of the space

size: Size in square feet

price_per_day: Rental cost per day in APT

is_rented: Rental status

rental_end_time: Timestamp of rental expiration

renter: Current renter's address

WarehouseCounter: Tracks the next available space_id.

🚀 Public Functions
initialize(owner: &signer)
Initializes the module by storing a WarehouseCounter under the owner's account.

create_space(owner: &signer, size: u64, price_per_day: u64)
Creates a new warehouse space NFT.

size: Size in square feet

price_per_day: Price per day in APT tokens

Requires:

initialize() must be called first.

rent_space(renter: &signer, owner_addr: address, space_id: u64, days: u64)
Allows a user to rent a warehouse space.

Transfers APT tokens from renter to owner_addr

Updates rental status and expiration time

⚠️ Error Codes
1 (E_NOT_OWNER): Caller is not the correct space owner

2 (E_ALREADY_RENTED): The space is currently rented

3 (E_RENTAL_ACTIVE): Rental already active (reserved for future use)

4 (E_INSUFFICIENT_PAYMENT): Not enough APT sent (currently unused but can be implemented)

📦 Storage
WarehouseNFT is stored under the creator's address

WarehouseCounter is stored under the admin/owner's address

🛠️ Future Improvements
Add support for NFT standardization and marketplace integration

Add event emissions for space creation and rentals

Allow cancellation or extension of rental

Implement penalty for early termination

🧪 Testing & Deployment
Use Aptos CLI and Move Prover for deploying and testing this module:

bash
Copy
Edit
aptos move compile
aptos move test
aptos move publish --package-dir .
Make sure to initialize the module first by calling initialize() before creating spaces.

📜 License
MIT License - Use freely with attribution.
