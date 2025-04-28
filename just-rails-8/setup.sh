#!/bin/bash
#
# initialize a new rails 8 app or start the existing one
#

if [ ! -d app ]
then
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
  apt install -y nodejs
  npm install -g yarn

  gem install just-rails-8/maglevcms-2.0.0.gem

  rails new . --database=sqlite3 --skip-action-cable

  bundle add maglevcms -v '~> 2.0.0'
  bundle add maglevcms-hyperui-kit -v '~> 1.2.0'
  bundle add image_processing
  bundle install

  grep cms Gemfile
  grep cms Gemfile.lock

  bundle exec rails db:create
  bundle exec rails active_storage:install
  bundle exec rails db:migrate
  bundle exec rails g maglev:install
  bundle exec rails g maglev:hyperui:install --force
  bundle exec rails maglev:create_site
fi

bundle exec rails server -b 0.0.0.0
