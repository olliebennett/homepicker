# HomePicker

Build a list of interesting homes and automatically pull in (and backup) data from Zoopla/Rightmove.

## Setup

- Setup Ruby and PostgreSQL

- Install dependencies

  ```
  gem install bundler
  bundle install
  ```

- Setup database;

  ```
  bundle exec rails db:create
  bundle exec rails db:schema:load
  ```

## Developing

- Test with `bundle exec rspec`.

- Start local server with `bundle exec rails s`
