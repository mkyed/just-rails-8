#!/bin/bash
#
# initialize a new rails 8 app or start the existing one
#

vanilla() {
  echo "#######################################"
  echo "### Installing vanilla Rails 8      ###"
  echo "#######################################"

  cp README.md README.md.bak 2>/dev/null || true
  rails new . --database=sqlite3 --skip-action-cable
  mv README.md.bak README.md 2>/dev/null || true
  bundle exec rails db:setup
}

maglev() {
  echo "#######################################"
  echo "## Installing Maglev CMS on Rails 8 ###"
  echo "#######################################"

  curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
  apt-get install -y nodejs

  cp README.md README.md.bak 2>/dev/null || true
  rails new . --database=sqlite3 --skip-action-cable
  mv README.md.bak README.md 2>/dev/null || true

  bundle add maglevcms -v '~> 2.1.0'
  bundle add maglevcms-hyperui-kit -v '~> 1.3.0'
  bundle install

  bundle exec rails db:create
  bundle exec rails active_storage:install
  bundle exec rails db:migrate
  bundle exec rails g maglev:install
  bundle exec rails g maglev:hyperui:install --force
  bundle exec rails maglev:create_site
}


if [ ! -d app ]
then
    case $JR8_FLAVOR in
      vanilla)
        vanilla
        ;;
      maglev)
        maglev
        ;;
      *)
        vanilla
        ;;
    esac
fi

bundle exec rails server -b 0.0.0.0
