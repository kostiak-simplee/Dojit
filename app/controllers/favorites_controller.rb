class FavoritesController < ApplicationController
  def create
    Favorite.create(params[:post_id], current_user.id)
    redirect_to :back
  end

  def destroy
    Favorite.destroy(params[:post_id], current_user.id)
    redirect_to :back
  end
  
end