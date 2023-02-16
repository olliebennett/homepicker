# frozen_string_literal: true

redis_uri = ENV.fetch('REDIS_URL')
REDIS = Redis.new(url: redis_uri)

Resque.redis = REDIS
