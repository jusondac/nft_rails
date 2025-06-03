# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create demo users
demo_user1 = User.find_or_create_by!(email: 'alice@example.com') do |user|
  user.name = 'Alice Johnson'
  user.password = 'password123'
  user.password_confirmation = 'password123'
end

demo_user2 = User.find_or_create_by!(email: 'bob@example.com') do |user|
  user.name = 'Bob Smith'
  user.password = 'password123'
  user.password_confirmation = 'password123'
end

demo_user3 = User.find_or_create_by!(email: 'charlie@example.com') do |user|
  user.name = 'Charlie Brown'
  user.password = 'password123'
  user.password_confirmation = 'password123'
end

puts "Created #{User.count} users"

# Create some demo NFTs for the users
demo_user1.nfts.find_or_create_by!(
  token_id: 'NFT001',
  title: 'Sunset Paradise',
  description: 'A beautiful sunset over the ocean',
  image_url: 'https://via.placeholder.com/400x400/ff6b6b/ffffff?text=Sunset+Paradise',
  metadata: {
    attributes: [
      { trait_type: 'Color Scheme', value: 'Warm' },
      { trait_type: 'Time of Day', value: 'Evening' },
      { trait_type: 'Rarity', value: 'Rare' }
    ],
    creator: 'Alice Johnson',
    collection: 'Nature Collection'
  }.to_json,
  blockchain: 'ethereum',
  contract_address: '0x1234567890abcdef1234567890abcdef12345678',
  mint_transaction_hash: '0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890ab',
  minting_status: 'completed',
  minted_at: Time.current
)

demo_user2.nfts.find_or_create_by!(
  token_id: 'NFT002',
  title: 'Digital Dreams',
  description: 'Abstract digital art with vibrant colors',
  image_url: 'https://via.placeholder.com/400x400/4ecdc4/ffffff?text=Digital+Dreams',
  metadata: {
    attributes: [
      { trait_type: 'Style', value: 'Abstract' },
      { trait_type: 'Color Palette', value: 'Vibrant' },
      { trait_type: 'Rarity', value: 'Common' }
    ],
    creator: 'Bob Smith',
    collection: 'Digital Art Collection'
  }.to_json,
  blockchain: 'polygon',
  contract_address: '0x9876543210fedcba9876543210fedcba98765432',
  mint_transaction_hash: '0xfedcba0987654321fedcba0987654321fedcba0987654321fedcba0987654321fe',
  minting_status: 'completed',
  minted_at: Time.current
)

demo_user3.nfts.find_or_create_by!(
  token_id: 'NFT003',
  title: 'Cosmic Journey',
  description: 'A journey through the cosmos with stars and galaxies',
  image_url: 'https://via.placeholder.com/400x400/45b7d1/ffffff?text=Cosmic+Journey',
  metadata: {
    attributes: [
      { trait_type: 'Theme', value: 'Space' },
      { trait_type: 'Complexity', value: 'High' },
      { trait_type: 'Rarity', value: 'Epic' }
    ],
    creator: 'Charlie Brown',
    collection: 'Space Collection'
  }.to_json,
  blockchain: 'ethereum',
  contract_address: '0x5555666677778888999900001111222233334444',
  mint_transaction_hash: '0x1111222233334444555566667777888899990000aaaabbbbccccddddeeeeffff11',
  minting_status: 'completed',
  minted_at: Time.current
)

puts "Created #{Nft.count} NFTs"
puts "Seed data created successfully!"
puts "Demo users created with email/password:"
puts "- alice@example.com / password123"
puts "- bob@example.com / password123"
puts "- charlie@example.com / password123"
