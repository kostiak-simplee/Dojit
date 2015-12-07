class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :post_id
  field :user_id
  field :body

  validates :body, length: { minimum: 5 }, presence: true
  validates :user_id, presence: true
  validates :post_id, presence: true

  def post
    Post.find(self.post_id)
  end

  def user
    User.find(self.user_id)
  end

  after_create :send_favorite_emails

  private

  def send_favorite_emails
    post.favorites.each do |user_id|
      p "sending to #{user_id}"
      FavoriteMailer.new_comment(User.find(user_id), post, self).deliver
    end
  end
end