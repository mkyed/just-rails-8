#!/bin/bash
#
# initialize a new rails 8 app or start the existing one
#

if [ ! -d app ]
then
  rails new . -m https://raw.githubusercontent.com/maglevhq/maglev-core/master/template.rb \
    --database=sqlite3 --skip-action-cable
fi

bundle exec rails server -b 0.0.0.0
