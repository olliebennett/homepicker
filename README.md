# HomePicker

Build a list of interesting homes and automtically pull in (and backup) data from Zoopla.

## Setup

- Setup Ruby and PostgreSQL

- Install dependencies

  ```
  gem install bundler
  bundle install
  ```

- Setup database;

  ```
  createdb homepicker_development
  createdb homepicker_test
  bundle exec rails db:schema:load
  ```

## Developing

- Test with `bundle exec rspec`.

- Start local server with `bundle exec rails s`
