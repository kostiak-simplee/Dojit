require 'rails_helper'

describe Vote do
  before(:all) do
    @topic = Topic.create(name: "abcde", description: "asdasdasdasdasdasdasdasdasdasdasdsd")
    5.times do |x|
      user = User.new(
        name: "user#{x}",
        email: "user#{x}@example.com",
        password: "12345678",
        password_confirmation: "12345678"
      )
      user.skip_confirmation!
      user.save
      @post = Post.create(
        title: "asdasdasd",
        body: "asdasdasdasdasdasdasdasdasdasdasdasd",
        topic: @topic,
        user: user
      )
    end
  end
  describe "Basic api" do
    before do
      $redis.select 1
      $redis.flushdb
    end

    it ".up_vote should create one vote on the point" do
      expect(Vote.up_vote(Post.first, User.first)).to eq(true)
      expect(User.first.voted?(Post.first)).to eq(true)
      expect(User.first.up_voted?(Post.first)).to eq(true)
      expect(User.first.down_voted?(Post.first)).to eq(false)
      expect(Post.first.voted?(User.first)).to eq(true)
      expect(Post.first.up_voted?(User.first)).to eq(true)
      expect(Post.first.down_voted?(User.first)).to eq(false)
    end

    it ".down_vote should create a vote instance" do
      expect(Vote.down_vote(Post.first, User.first)).to eq(true)
      expect(User.first.voted?(Post.first)).to eq(true)
      expect(User.first.up_voted?(Post.first)).to eq(false)
      expect(User.first.down_voted?(Post.first)).to eq(true)
      expect(Post.first.voted?(User.first)).to eq(true)
      expect(Post.first.up_voted?(User.first)).to eq(false)
      expect(Post.first.down_voted?(User.first)).to eq(true)
    end

    it ".up_vote twice should return false" do
      expect(Vote.up_vote(Post.first, User.first)).to eq(true)
      expect(Vote.up_vote(Post.first, User.first)).to eq(false)
      expect(User.first.voted?(Post.first)).to eq(true)
      expect(User.first.up_voted?(Post.first)).to eq(true)
      expect(User.first.down_voted?(Post.first)).to eq(false)
      expect(Post.first.voted?(User.first)).to eq(true)
      expect(Post.first.up_voted?(User.first)).to eq(true)
      expect(Post.first.down_voted?(User.first)).to eq(false)
    end

    it ".up_vote then .down_vote should leave only the downvote" do
      expect(Vote.up_vote(Post.first, User.first)).to eq(true)
      expect(Vote.down_vote(Post.first, User.first)).to eq(true)
      expect(User.first.voted?(Post.first)).to eq(true)
      expect(User.first.up_voted?(Post.first)).to eq(false)
      expect(User.first.down_voted?(Post.first)).to eq(true)
      expect(Post.first.voted?(User.first)).to eq(true)
      expect(Post.first.up_voted?(User.first)).to eq(false)
      expect(Post.first.down_voted?(User.first)).to eq(true)
    end

    it ".remove_up_vote should remove the upvote" do
      expect(Vote.up_vote(Post.first, User.first)).to eq(true)
      expect(Vote.remove_up_vote(Post.first, User.first)).to eq(true)
      expect(User.first.voted?(Post.first)).to eq(false)
      expect(User.first.up_voted?(Post.first)).to eq(false)
      expect(User.first.down_voted?(Post.first)).to eq(false)
      expect(Post.first.voted?(User.first)).to eq(false)
      expect(Post.first.up_voted?(User.first)).to eq(false)
      expect(Post.first.down_voted?(User.first)).to eq(false)
    end

    it ".remove_down_vote should remove the upvote" do
      expect(Vote.down_vote(Post.first, User.first)).to eq(true)
      expect(Vote.remove_down_vote(Post.first, User.first)).to eq(true)
      expect(User.first.voted?(Post.first)).to eq(false)
      expect(User.first.up_voted?(Post.first)).to eq(false)
      expect(User.first.down_voted?(Post.first)).to eq(false)
      expect(Post.first.voted?(User.first)).to eq(false)
      expect(Post.first.up_voted?(User.first)).to eq(false)
      expect(Post.first.down_voted?(User.first)).to eq(false)
    end

  end

  describe "Points" do
    before do
      $redis.select 1
      $redis.flushdb
    end

    it "Post#points after 1 upvote" do
      expect(Vote.up_vote(Post.first, User.first)).to eq(true)
      expect(Post.first.up_votes).to eq(1)
      expect(Post.first.down_votes).to eq(0)
      expect(Post.first.points).to eq(1)
    end

    it "Post#points after 1 downvote" do
      expect(Vote.down_vote(Post.first, User.first)).to eq(true)
      expect(Post.first.up_votes).to eq(0)
      expect(Post.first.down_votes).to eq(1)
      expect(Post.first.points).to eq(-1)
    end

    it "Post#points after 3 upvotes" do
      users = User.all
      3.times do |x|
        expect(Vote.up_vote(Post.first, users[x])).to eq(true)
      end
      expect(Post.first.up_votes).to eq(3)
      expect(Post.first.down_votes).to eq(0)
      expect(Post.first.points).to eq(3)
    end

    it "Post#points after upvote and downvote from same user" do
      expect(Vote.up_vote(Post.first, User.first)).to eq(true)
      expect(Vote.down_vote(Post.first, User.first)).to eq(true)
      expect(Post.first.up_votes).to eq(0)
      expect(Post.first.down_votes).to eq(1)
      expect(Post.first.points).to eq(-1)
    end

    it "Post#points after upvote and downvote from different users" do
      users = User.all
      expect(Vote.up_vote(Post.first, users[0])).to eq(true)
      expect(Vote.down_vote(Post.first, users[1])).to eq(true)
      expect(Post.first.up_votes).to eq(1)
      expect(Post.first.down_votes).to eq(1)
      expect(Post.first.points).to eq(0)
    end
  end

end