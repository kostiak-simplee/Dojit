class Favorite
  def self.create(post_id, user_id)
    $redis.sadd "#{post_id}_favorites", user_id
  end

  def self.destroy(post_id, user_id)
    $redis.srem "#{post_id}_favorites", user_id
  end

  def self.favorited?(post_id, user_id)
    $redis.sismember "#{post_id}_favorites", user_id.to_s
  end

  def self.favorites(post_id)
    $redis.smembers "#{post_id}_favorites"
  end
end