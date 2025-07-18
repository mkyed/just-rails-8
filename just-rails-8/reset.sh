#!/bin/bash
#
# clean out and rebuild the docker image
#

help=0
verbose=0
clean_untracked=0

# Parse options
while [[ $# -gt 0 ]]; do
    case "$1" in
        --clean-untracked|-cu)
            clean_untracked=1
            shift
            ;;
        --verbose|-v)
            verbose=1
            shift
            ;;
        --help|-h)
            help=1
            shift
            ;;
        -*)
            echo "Invalid option: $1" >&2
            help=1
            shift
            ;;
        *)
            break
            ;;
    esac
done


# need help?
if [ $help -eq 1 ]; then
  echo "Usage: $0 [--clean-untracked] [--verbose] [--help]"
  (( verbose == 1 )) && echo "This command resets the docker stuff in the current directory to help in debugging your docker files, and optionally removes all untracked files and directories."
  (( verbose == 1 )) && echo "Options:"
  (( verbose == 1 )) && echo "  --clean-untracked, -cu: remove all untracked files and directories"
  (( verbose == 1 )) && echo "  --verbose, -v: enable verbose output"
  (( verbose == 1 )) && echo "  --help, -h: show this help message"
  exit 1
fi


DIR=`pwd`
NAME=`basename ${DIR}`
(( verbose == 1 )) && echo "### Docker name: ${NAME}"

(( verbose == 1 )) && echo "### Running: docker compose down..."
docker compose down

volumes=$(docker volume ls -q --filter name=${NAME})
if [ -z "$volumes" ]; then
  (( verbose == 1 )) && echo "### No volumes to remove."
else
  (( verbose == 1 )) && echo "### Removing volumes: $volumes"
  docker volume rm $(docker volume ls -q --filter name=${NAME})
fi

(( verbose == 1 )) && echo "### Running: docker network rm..."
docker network rm ${NAME}_default 2>/dev/null

(( verbose == 1 )) && echo "### Running: docker image rm..."
docker image rm ${NAME}-web 2>/dev/null

if [ $clean_untracked -eq 1 ]; then
  (( verbose == 1 )) && echo "### Removing all untracked files and directories..."
  git clean -ffdx
fi

# Revert README.md changes if it was overwritten by Rails
if [ -f README.md ]; then
  # Check if README.md contains Rails default content
  if grep -q "This README would normally document whatever steps are necessary" README.md; then
    (( verbose == 1 )) && echo "### Reverting README.md changes..."
    git checkout README.md 2>/dev/null || true
  fi
fi

# Remove Rails-generated files that are not tracked by git
RAILS_FILES=".dockerignore .gitattributes .github .gitignore .kamal .rubocop.yml .ruby-version .claude"
for file in $RAILS_FILES; do
  if [ -e "$file" ]; then
    (( verbose == 1 )) && echo "### Removing Rails file: $file"
    rm -rf "$file"
  fi
done


