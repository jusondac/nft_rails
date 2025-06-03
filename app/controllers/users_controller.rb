class UsersController < ApplicationController
  before_action :require_logout, only: [ :new, :create ]
  before_action :require_login, only: [ :show, :profile ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to NFT Trials, #{@user.name}!"
      redirect_to dashboard_path
    else
      flash.now[:error] = "There was an error creating your account"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = current_user
    @posts = @user.posts.includes(:nft, image_attachment: :blob).recent
    @nfts = @user.nfts.minted.recent
  end

  def profile
    @user = current_user
    @stats = {
      total_posts: @user.posts.count,
      total_nfts: @user.nfts.count,
      minted_nfts: @user.nfts.minted.count,
      pending_nfts: @user.nfts.pending.count
    }
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
