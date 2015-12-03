class Vote
  def self.up_vote(post, user)
    $redis.srem("#{post.id}_down", user.id)
    ret = $redis.sadd("#{post.id}_up", user.id)
    update_post(post)
    ret
  end

  def self.down_vote(post, user)
    $redis.srem("#{post.id}_up", user.id)
    ret = $redis.sadd("#{post.id}_down", user.id)
    update_post(post)
    ret
  end

  def self.remove_up_vote(post, user)
    ret = $redis.srem("#{post.id}_up", user.id)
    update_post(post)
    ret
  end

  def self.remove_down_vote(post, user)
    ret = $redis.srem("#{post.id}_down", user.id)
    update_post(post)
    ret
  end

  private

  def self.update_post(post)
    post.update_rank
  end
end