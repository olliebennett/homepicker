# frozen_string_literal: true

redis_uri = URI.parse(ENV.fetch('REDIS_URL'))
REDIS = Redis.new(url: redis_uri)

Resque.redis = REDIS
