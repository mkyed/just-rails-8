#!/bin/bash
#
# initialize a new rails 8 app or start the existing one
#

if [ ! -d app ]
then
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
  apt-get update
  apt install -y nodejs
  npm install -g yarn

  node --version
  npm --version
  yarn --version

  gem install just-rails-8/maglevcms-2.0.0.gem
  rails new . -m https://raw.githubusercontent.com/maglevhq/maglev-core/master/template.rb \
    --database=sqlite3 --skip-action-cable
fi

bundle exec rails server -b 0.0.0.0
