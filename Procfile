web: bundle exec puma -C config/puma.rb
release: bundle exec rake db:migrate
resque: env TERM_CHILD=1 RESQUE_TERM_TIMEOUT=7 QUEUE=* bundle exec rake environment resque:work
