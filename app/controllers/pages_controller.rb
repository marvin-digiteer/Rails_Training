class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  def home
     @posts = Post.where(featured:true, active: true)
               .where("created_at <= ?", Time.current)
               .order(created_at: :desc).limit(5)
  end

  def about
  end
end
