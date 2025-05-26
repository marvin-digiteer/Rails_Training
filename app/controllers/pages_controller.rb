class PagesController < ApplicationController
  skip_before_action :authenticate_user_or_customer!, only: [:home]

  def home
     @posts = Post.where(featured:true, active: true)
               .where("created_at <= ?", Time.current)
               .order(created_at: :desc).limit(5)
      @featured_ids = @posts.pluck(:id)
  end

  def feed
    @posts = Post.where(active: true)
                 .order(created_at: :desc)
  end
end
