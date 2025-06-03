class NftMintingService
  include HTTParty

  attr_reader :post, :errors

  def initialize(post)
    @post = post
    @errors = []
  end

  def call
    return false unless valid_post?

    begin
      # Update post status to minting
      post.update!(status: "minting")
      byebug
      # Generate metadata
      metadata = generate_metadata

      # Create NFT record
      nft = create_nft_record(metadata)

      # Simulate blockchain minting (replace with actual blockchain integration)
      token_id = mint_to_blockchain(nft, metadata)

      if token_id
        # Update NFT with minting details
        nft.update!(
          token_id: token_id,
          minted_at: Time.current,
          contract_address: default_contract_address
        )

        # Update post status and link to NFT
        post.update!(status: "minted", nft: nft)

        true
      else
        post.update!(status: "failed")
        @errors << "Failed to mint NFT on blockchain"
        false
      end

    rescue StandardError => e
      post.update!(status: "failed")
      @errors << e.message
      Rails.logger.error "NFT Minting failed for post #{post.id}: #{e.message}"
      false
    end
  end

  private

  def valid_post?
    unless post&.image&.attached?
      @errors << "Post must have an attached image"
      return false
    end

    unless post.status == "pending"
      @errors << "Post status must be pending"
      return false
    end

    true
  end

  def generate_metadata
    {
      name: post.title,
      description: post.description || "Digital artwork created by #{post.user.name}",
      image: post.image_url,
      attributes: [
        {
          trait_type: "Creator",
          value: post.user.name
        },
        {
          trait_type: "Created Date",
          value: post.created_at.strftime("%Y-%m-%d")
        },
        {
          trait_type: "File Type",
          value: post.image.content_type
        }
      ],
      creator: {
        name: post.user.name,
        email: post.user.email
      },
      created_at: post.created_at.iso8601
    }
  end

  def create_nft_record(metadata)
    # Generate a temporary token_id that will be updated after minting
    temp_token_id = "TEMP_#{SecureRandom.hex(8)}"

    post.user.nfts.create!(
      title: post.title,
      description: post.description,
      metadata: metadata.to_json,
      blockchain: "ethereum",
      token_id: temp_token_id
    )
  end

  def mint_to_blockchain(nft, metadata)
    # This is a simulation of blockchain minting
    # In a real application, you would integrate with services like:
    # - OpenSea API
    # - Moralis
    # - Alchemy
    # - Web3 libraries

    # For demo purposes, generate a mock token ID
    "#{Time.current.to_i}#{nft.id}#{rand(1000..9999)}"
  end

  def default_contract_address
    # This would be your actual NFT contract address
    Rails.application.credentials.dig(:nft, :contract_address) ||
      "0x1234567890abcdef1234567890abcdef12345678"
  end
end
