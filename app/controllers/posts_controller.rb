class PostsController < ApplicationController
  before_action :logged_in_user, only: :destroy
  before_action :correct_user,   only: :destroy

  def home
    @title = "Edited by everyone"
    @posts = Post.all.order(updated_at: "DESC").paginate(page: params[:page])
    render 'index'
  end

  
  def index
    @title = "Everyone touched"
    @posts = Post.all.order(created_at: "DESC").paginate(page: params[:page])
  end

  def show
  end
  
  def new
    @post = Post.new
    # @post = current_user.posts.build if logged_in?
  end

  def create
    user = current_user
    user ||= User.find_by(name: "Guest")
    @post = user.posts.build(post_params)
    if @post.save
      flash[:success] = "Post created!"
      redirect_to root_url
    else
      render 'posts/new'
    end
  end

  def destroy
    @post.destroy
    flash[:success] = "Post deleted"
    redirect_to request.referrer || root_url
  end

  private

    def post_params
      params.require(:post).permit(:content)
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end

end
