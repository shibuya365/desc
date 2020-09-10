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
    previous_location
    @post = Post.find(params[:id])
    render 'edit' if current_user?(@post.user)
  end
  
  def new
    @post = Post.new
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

  def edit
    previous_location
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if params[:post][:addendum] == nil
      if @post.update_attributes(post_params)
        flash[:success] = "Post updated"
      else
        render 'show'
      end
    else
      @post.content += "\n"
      @post.content += params[:post][:addendum]
      @post.save
    end
    redirect_back_or(root_url)
  end
  
  def destroy
    @post.destroy
    flash[:success] = "Post deleted"
    redirect_to request.referrer || root_url
  end

  def append

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
