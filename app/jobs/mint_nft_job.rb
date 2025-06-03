class MintNftJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: 30.seconds, attempts: 3

  def perform(post)
    return unless post.is_a?(Post) && post.can_mint?

    service = NftMintingService.new(post)

    if service.call
      Rails.logger.info "Successfully minted NFT for post #{post.id}"
      # You could add notifications here
    else
      Rails.logger.error "Failed to mint NFT for post #{post.id}: #{service.errors.join(', ')}"
      # You could add error notifications here
    end
  end
end
