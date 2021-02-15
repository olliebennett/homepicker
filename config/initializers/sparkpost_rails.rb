# frozen_string_literal: true

SparkPostRails.configure do |c|
  c.api_key = ENV.fetch('SPARKPOST_API_KEY', '')
  c.api_endpoint = 'https://api.eu.sparkpost.com/api/'
  c.transactional = true
  c.subaccount = ENV.fetch('SPARKPOST_SUBACCOUNT_ID', nil)
end
