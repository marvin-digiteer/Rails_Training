class Admin::PostsController < ApplicationController
  before_action :authenticate_user!  # or your admin auth logic
  before_action :set_post, only: [:show, :edit, :update, :destroy, :toggle_featured, :toggle_active]


  # GET /posts or /posts.json
  def index
    @posts = Post.order(active: :desc, created_at: :desc)
    @featured_ids = Post.where(active:true, featured: true)
                    .where("created_at <= ?", Time.current)
                    .order(created_at: :desc)
                    .limit(5)
                    .pluck(:id)


  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!
    respond_to do |format|
      format.turbo_stream # renders destroy.turbo_stream.erb
      format.html { redirect_to admin_posts_path, notice: "Post was successfully deleted." }
    end
  end
  def toggle_featured
    @post = Post.find(params[:id])
    @post.update(featured: !@post.featured)
    respond_to do |format|
      format.turbo_stream # renders toggle_featured.turbo_stream.erb
      format.html { redirect_to admin_posts_path, notice: "Post updated." }
    end
  end
  def toggle_active
    @post.update(active: !@post.active)
    redirect_to admin_posts_path, notice: "Post active status updated."
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.expect(post: [ :title, :body, :active, :created_at, :featured ])
    end
end
