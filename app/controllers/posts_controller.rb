class PostsController < ApplicationController
  before_action :require_login
  before_action :set_post, only: [ :show, :edit, :update, :destroy ]
  before_action :check_post_owner, only: [ :edit, :update, :destroy ]

  def index
    @posts = current_user.posts.includes(:nft, image_attachment: :blob).recent
    @minted_posts = @posts.minted
    @pending_posts = @posts.pending_mint
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      flash[:success] = "Your image has been uploaded and will be minted as an NFT soon!"
      redirect_to @post
    else
      flash.now[:error] = "There was an error uploading your image"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @nft = @post.nft
  end

  def edit
    # Only allow editing if not yet minted
    if @post.minted?
      flash[:error] = "Cannot edit a post that has already been minted as NFT"
      redirect_to @post
    end
  end

  def update
    if @post.minted?
      flash[:error] = "Cannot update a post that has already been minted as NFT"
      redirect_to @post
    elsif @post.update(post_params.except(:image))
      flash[:success] = "Post updated successfully"
      redirect_to @post
    else
      flash.now[:error] = "There was an error updating your post"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @post.minted?
      flash[:error] = "Cannot delete a post that has been minted as NFT"
      redirect_to @post
    else
      @post.destroy
      flash[:success] = "Post deleted successfully"
      redirect_to posts_path
    end
  end

  private

  def set_post
    @post = current_user.posts.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Post not found"
    redirect_to posts_path
  end

  def check_post_owner
    unless @post.user == current_user
      flash[:error] = "You can only manage your own posts"
      redirect_to posts_path
    end
  end

  def post_params
    params.require(:post).permit(:title, :description, :image)
  end
end
