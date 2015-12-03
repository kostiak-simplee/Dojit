class VotesController < ApplicationController
  before_action :load_post

  def up_vote
    Vote.up_vote(@post, current_user) if current_user

    redirect_to :back
  end

  def down_vote
    Vote.down_vote(@post, current_user) if current_user

    redirect_to :back
  end

  def remove_up_vote
    Vote.remove_up_vote(@post, current_user) if current_user

    redirect_to :back
  end

  def remove_down_vote
    Vote.remove_down_vote(@post, current_user) if current_user

    redirect_to :back
  end

  private

  def load_post
    @post = Post.find(params[:post_id])
  end

end