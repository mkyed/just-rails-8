#!/bin/bash
#
# initialize a new rails 8 app or start the existing one
#

if [ ! -d app ]
then
  rails new . --database=sqlite3 --force --quiet
  bundle exec rails db:setup 
fi

bundle exec rails server -b 0.0.0.0
