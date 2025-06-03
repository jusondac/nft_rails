class NftsController < ApplicationController
  before_action :require_login
  before_action :set_nft, only: [ :show ]

  def index
    @nfts = current_user.nfts.minted.includes(:post, :user).recent
    @total_nfts = @nfts.count
    @ethereum_nfts = @nfts.by_blockchain("ethereum").count
  end

  def show
    @post = @nft.post
  end

  private

  def set_nft
    @nft = current_user.nfts.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "NFT not found"
    redirect_to nfts_path
  end
end
