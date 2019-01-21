class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  before_action :set_post, only: [:show]

  def show
  end

  def new
  end

  def create
  end

  private

  def set_post
    @post = Post.find_by(slug: params[:slug])
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
