# frozen_string_literal: true

##########################
# Gemfile for homepicker #
##########################

source 'https://rubygems.org'

ruby '3.2.3'

# Remove whitespace before field validation
gem 'auto_strip_attributes'

# Debug: Improved error page display
gem 'better_errors', group: :development

# Security audit checks (eg. SQL injection)
gem 'brakeman', require: false, group: %i[development test]

# Improve applicaion boot speed
gem 'bootsnap', require: false

# Detect N+1 query issues
gem 'bullet', group: :development

# Call 'byebug' anywhere in the code to stop execution and get a debugger console
gem 'byebug', platform: :mri, group: %i[development test]

# Authentication
gem 'devise'

# Load '.env' file into ENV
gem 'dotenv', groups: %i[development test]

# Replace raw numeric IDs with short unique ids
gem 'hashid-rails'

# Support dialogues, link HTTP verb changes and form-submit improvements
gem 'jquery-rails'

gem 'listen'

# HTML Parsing (for crawler)
gem 'nokogiri', require: false

# Version history tracking
gem 'paper_trail'

# PostgreSQL Database
gem 'pg'

# Use Puma as the app server
gem 'puma'

# Ruby on Rails framework
gem 'rails'

# Markdown renderer
gem 'redcarpet'

# Background job library on top of Redis
gem 'resque'

# RSpec testing framework
gem 'rspec-rails', group: %i[development test]

# Ruby syntax/formatting checking (and associated Cop plugins)
gem 'rubocop', require: false, group: %i[development test]
gem 'rubocop-performance', group: %i[development test]
gem 'rubocop-rails', group: %i[development test]
gem 'rubocop-rspec', group: %i[development test]
gem 'rubocop-thread_safety', group: %i[development test]

# RuboCop for ERB view files
gem 'ruumba'

# Sentry.io error tracking
gem 'sentry-rails'
gem 'sentry-ruby'

# Send emails via SparkPost
# https://github.com/the-refinery/sparkpost_rails/pull/89
gem 'sparkpost_rails', github: 'sunny/sparkpost_rails', branch: 'allow-rails-seven'

# Asset serving (not included in Rails 7+)
gem 'sprockets-rails'

# Find misconfigured or unused routes
gem 'traceroute'

# Image upload and thumbnailing
gem 'transloadit', require: false

# Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
gem 'web-console', group: :development
