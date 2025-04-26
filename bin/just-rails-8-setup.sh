#!/bin/bash
#
# initialize a new rails 8 app or start the existing one
#

if [ ! -d app ]
then
  rails new . --database=sqlite3 --force
  bundle exec rails db:setup 
  bundle exec rails db:migrate db:test:prepare
fi

bundle exec rails server -b 0.0.0.0
