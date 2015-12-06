require 'rails_helper'

describe Vote do
  
  include TestFactories

  before(:all) do
    @topic = Topic.create(name: "abcde", description: "asdasdasdasdasdasdasdasdasdasdasdsd")
    @users = []
    @posts = []
    5.times do |x|
      @users << authenticated_user(name: "user#{x}", email: "user#{x}@examp.com")
      @posts << associated_post(user: @users.last)
    end
  end

  describe "Basic api" do
    before do
      $redis.select 1
      $redis.flushdb
    end

    it ".up_vote should create one vote on the point" do
      expect(Vote.up_vote(@posts[0], @users[0])).to eq(true)
      expect(@users[0].voted?(@posts[0])).to eq(true)
      expect(@users[0].up_voted?(@posts[0])).to eq(true)
      expect(@users[0].down_voted?(@posts[0])).to eq(false)
      expect(@posts[0].voted?(@users[0])).to eq(true)
      expect(@posts[0].up_voted?(@users[0])).to eq(true)
      expect(@posts[0].down_voted?(@users[0])).to eq(false)
    end

    it ".down_vote should create a vote instance" do
      expect(Vote.down_vote(@posts[0], @users[0])).to eq(true)
      expect(@users[0].voted?(@posts[0])).to eq(true)
      expect(@users[0].up_voted?(@posts[0])).to eq(false)
      expect(@users[0].down_voted?(@posts[0])).to eq(true)
      expect(@posts[0].voted?(@users[0])).to eq(true)
      expect(@posts[0].up_voted?(@users[0])).to eq(false)
      expect(@posts[0].down_voted?(@users[0])).to eq(true)
    end

    it ".up_vote twice should return false" do
      expect(Vote.up_vote(@posts[0], @users[0])).to eq(true)
      expect(Vote.up_vote(@posts[0], @users[0])).to eq(false)
      expect(@users[0].voted?(@posts[0])).to eq(true)
      expect(@users[0].up_voted?(@posts[0])).to eq(true)
      expect(@users[0].down_voted?(@posts[0])).to eq(false)
      expect(@posts[0].voted?(@users[0])).to eq(true)
      expect(@posts[0].up_voted?(@users[0])).to eq(true)
      expect(@posts[0].down_voted?(@users[0])).to eq(false)
    end

    it ".up_vote then .down_vote should leave only the downvote" do
      expect(Vote.up_vote(@posts[0], @users[0])).to eq(true)
      expect(Vote.down_vote(@posts[0], @users[0])).to eq(true)
      expect(@users[0].voted?(@posts[0])).to eq(true)
      expect(@users[0].up_voted?(@posts[0])).to eq(false)
      expect(@users[0].down_voted?(@posts[0])).to eq(true)
      expect(@posts[0].voted?(@users[0])).to eq(true)
      expect(@posts[0].up_voted?(@users[0])).to eq(false)
      expect(@posts[0].down_voted?(@users[0])).to eq(true)
    end

    it ".remove_up_vote should remove the upvote" do
      expect(Vote.up_vote(@posts[0], @users[0])).to eq(true)
      expect(Vote.remove_up_vote(@posts[0], @users[0])).to eq(true)
      expect(@users[0].voted?(@posts[0])).to eq(false)
      expect(@users[0].up_voted?(@posts[0])).to eq(false)
      expect(@users[0].down_voted?(@posts[0])).to eq(false)
      expect(@posts[0].voted?(@users[0])).to eq(false)
      expect(@posts[0].up_voted?(@users[0])).to eq(false)
      expect(@posts[0].down_voted?(@users[0])).to eq(false)
    end

    it ".remove_down_vote should remove the upvote" do
      expect(Vote.down_vote(@posts[0], @users[0])).to eq(true)
      expect(Vote.remove_down_vote(@posts[0], @users[0])).to eq(true)
      expect(@users[0].voted?(@posts[0])).to eq(false)
      expect(@users[0].up_voted?(@posts[0])).to eq(false)
      expect(@users[0].down_voted?(@posts[0])).to eq(false)
      expect(@posts[0].voted?(@users[0])).to eq(false)
      expect(@posts[0].up_voted?(@users[0])).to eq(false)
      expect(@posts[0].down_voted?(@users[0])).to eq(false)
    end

  end

  describe "Points" do
    before do
      $redis.select 1
      $redis.flushdb
    end

    it "Post#points after 1 upvote" do
      expect(Vote.up_vote(@posts[0], @users[0])).to eq(true)
      expect(@posts[0].up_votes).to eq(1)
      expect(@posts[0].down_votes).to eq(0)
      expect(@posts[0].points).to eq(1)
    end

    it "Post#points after 1 downvote" do
      expect(Vote.down_vote(@posts[0], @users[0])).to eq(true)
      expect(@posts[0].up_votes).to eq(0)
      expect(@posts[0].down_votes).to eq(1)
      expect(@posts[0].points).to eq(-1)
    end

    it "Post#points after 3 upvotes" do
      3.times do |x|
        expect(Vote.up_vote(@posts[0], @users[x])).to eq(true)
      end
      expect(@posts[0].up_votes).to eq(3)
      expect(@posts[0].down_votes).to eq(0)
      expect(@posts[0].points).to eq(3)
    end

    it "Post#points after upvote and downvote from same user" do
      expect(Vote.up_vote(@posts[0], @users[0])).to eq(true)
      expect(Vote.down_vote(@posts[0], @users[0])).to eq(true)
      expect(@posts[0].up_votes).to eq(0)
      expect(@posts[0].down_votes).to eq(1)
      expect(@posts[0].points).to eq(-1)
    end

    it "Post#points after upvote and downvote from different users" do
      expect(Vote.up_vote(@posts[0], @users[0])).to eq(true)
      expect(Vote.down_vote(@posts[0], @users[1])).to eq(true)
      expect(@posts[0].up_votes).to eq(1)
      expect(@posts[0].down_votes).to eq(1)
      expect(@posts[0].points).to eq(0)
    end
  end

end