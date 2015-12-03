uri = URI.parse(ENV["REDIS_URL"])
$redis = Redis.new(host: uri.host, post: uri.port, password: uri.password)
