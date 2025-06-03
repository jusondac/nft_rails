class HomeController < ApplicationController
  before_action :require_login, only: [ :dashboard ]

  def index
    if logged_in?
      redirect_to dashboard_path
    end
  end

  def dashboard
    @user = current_user
    @recent_posts = @user.posts.includes(:nft, image_attachment: :blob).recent.limit(5)
    @total_nfts = @user.nfts.minted.count
    @pending_mints = @user.posts.pending_mint.count
    @recent_nfts = @user.nfts.minted.recent.limit(3)
  end
end
