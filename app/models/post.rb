class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic

  default_scope { order('rank DESC') }

  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true
  validates :topic, presence: true
  validates :user, presence: true

  after_create :create_vote

  before_destroy do |post|
    post.comments.destroy
  end

  def comments
    Comment.where(post_id: self.id)
  end

  def up_voted?(user)
    $redis.sismember("#{id}_up", user.id)
  end

  def down_voted?(user)
    $redis.sismember("#{id}_down", user.id)
  end

  def voted?(user)
    up_voted?(user) || down_voted?(user)
  end

  def up_votes
    $redis.scard("#{id}_up")
  end

  def down_votes
    $redis.scard("#{id}_down")
  end

  def points
    up_votes - down_votes
  end

  def update_rank
    age_in_days = (created_at - Time.new(1970,1,1)) / (60 * 60 * 24)
    new_rank = points + age_in_days

    update_attribute(:rank, new_rank)
  end

  def favorites
    Favorite.favorites(id)
  end

  private

  def create_vote
    Vote.up_vote(self, user)
  end
end
