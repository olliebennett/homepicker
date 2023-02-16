web: bundle exec puma -C config/puma.rb
# Note: release `db:migrate` will fail on first deploy. To fix: comment out the `release` line below, deploy, do `heroku run rails db:schema:load`, then reinstate the `release` line.
release: bundle exec rake db:migrate
resque: env TERM_CHILD=1 RESQUE_TERM_TIMEOUT=7 QUEUE=* bundle exec rake environment resque:work
