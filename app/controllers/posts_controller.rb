class PostsController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]

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
    @post.update_attribute(:created_at, Time.now)
    render 'edit' if current_user?(@post.user)
  end
  
  def new
    @post = Post.new
  end

  def create
    @post = current_or_guest.posts.build(post_params)
    if @post.save
      flash[:success] = "Post created!"
      redirect_to root_url
    else
      render 'posts/new'
    end
  end

  # def edit
  #   previous_location
  #   @post = Post.find(params[:id])
  # end
  
  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      flash[:success] = "Post updated"
      redirect_back_or(root_url)
    else
      render 'show'
    end
  end
  
  def destroy
    @post.destroy
    flash[:success] = "Post deleted"
    redirect_to request.referrer || root_url
  end

  def append
    if !params[:post][:addendum].blank?
      @post = Post.find(params[:id])
      @post.content += "\n" + "---" + "\n" + Time.now.to_s + "\n" + current_or_guest.name + "\n" + params[:post][:addendum]
      @post.save
    end
    redirect_back_or(root_url)
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
