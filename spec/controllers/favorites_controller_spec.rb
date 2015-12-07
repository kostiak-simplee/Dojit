require 'rails_helper'

describe FavoritesController do
  include TestFactories
  include Devise::TestHelpers
  before(:all) do
    $redis.select 1
    $redis.flushdb
  end

  before do
    request.env["HTTP_REFERER"] = '/'
    @post = associated_post
    @user = authenticated_user
    sign_in @user
  end

  describe '#create' do
    it "creates a favorite for the current user and specified post" do
      expect( @user.favorited?(@post.id) ).to eq(false)

      post :create, {post_id: @post.id}

      expect( @user.favorited?(@post.id) ).to eq(true)      
    end
  end

  describe '#destroy' do
    it "destroys the favorite for the current user and post" do

      expect( @user.favorited?(@post.id) ).to eq(true)

      delete :destroy, { post_id: @post.id, id: 0 }

      expect( @user.favorited?(@post.id) ).to eq(false)
    end
  end
end