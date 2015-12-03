class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :posts

  def admin?
    role == 'admin'
  end

  def moderator?
    role == 'moderator'
  end

  def avatar?
    false
  end

  def up_voted?(post)
    $redis.sismember("#{post.id}_up", id)
  end

  def down_voted?(post)
    $redis.sismember("#{post.id}_down", id)
  end

  def voted?(post)
    up_voted?(post) || down_voted?(post)
  end
end
