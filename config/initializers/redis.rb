# frozen_string_literal: true

# Workaround to use externally managed ENV var by fetching the specified config key instead
redis_uri = ENV.fetch('REDIS_URL') { |_| ENV.fetch(ENV.fetch('REDIS_URL_ENV_KEY')) }
REDIS = Redis.new(url: redis_uri)

Resque.redis = REDIS
