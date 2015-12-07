require 'rails_helper'

describe User do
  include TestFactories

  before(:all) do
    $redis.select 1
    $redis.flushdb
  end

  before do
    @post = associated_post
    @user = authenticated_user
  end

  describe "#favorited?(post)" do
    it "returns false if the user has not favorited the post" do
      expect(@user.favorited?(@post.id)).to eq(false)
    end

    it "returns true if the user has favorited the post" do
      @user.favorite(@post.id)
      expect(@user.favorited?(@post.id)).to eq(true)
    end
  end
end