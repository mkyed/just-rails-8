#!/bin/bash

if [ ! -d app ]
then
  rails new . --database=sqlite3 --force
  bundle exec rails db:setup 
  bundle exec rails db:migrate db:test:prepare
fi

bundle exec rails server -b 0.0.0.0
