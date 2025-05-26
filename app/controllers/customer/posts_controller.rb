class Customer::PostsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_customer!, only: [:edit, :update, :destroy, :show]

  def index
    # Only show posts belonging to logged-in customer
    @posts = Post.where("created_at <= ?", Time.current)
                 .order(created_at: :desc)
  end

  def new
    @post = current_customer.posts.build
  end

  def create
    @post = current_customer.posts.build(post_params)
    if @post.save
      redirect_to customer_posts_path, notice: "Post created!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to customer_posts_path, notice: "Post updated!"
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to customer_posts_path, notice: "Post deleted!"
  end

  private

  def set_post
    @post = current_customer.posts.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to customer_posts_path, alert: "Post not found or you are not authorized."
  end

  def authorize_customer!
    redirect_to customer_posts_path, alert: "Not authorized" unless @post.customer == current_customer
  end

  def post_params
    params.require(:post).permit(:title, :body, :active, :created_at)
  end
end
