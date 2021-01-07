# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

require 'resque/tasks'

Rails.application.load_tasks

# Workaround missing 'bin/yarn'
# https://github.com/rails/rails/issues/40795#issuecomment-756095119
# rubocop:disable Rails/RakeEnvironment
Rake::Task['yarn:install'].clear
namespace :yarn do
  task :install do
    # Do nothing, since there's no yarn
  end
end
# rubocop:enable Rails/RakeEnvironment
