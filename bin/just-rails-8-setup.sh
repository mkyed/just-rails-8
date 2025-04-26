#!/bin/bash

if [ ! -d app ]
then
  rails new . --database=sqlite3 --force
  bundle exec rails db:setup 
fi

bundle exec rails server -b 0.0.0.0
