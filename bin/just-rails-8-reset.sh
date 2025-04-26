#!/bin/bash
#
# clean out and rebuild the docker image
#

help=0
verbose=0
clean_git=0

# Parse options
while [[ $# -gt 0 ]]; do
    case "$1" in
        --clean-git|-cg)
            clean_git=1
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
  echo "Usage: $0 [--clean-git] [--verbose] [--help]"
  (( verbose == 1 )) && echo "This command resets the docker stuff in the current directory to help in debugging your docker files, possibly cleaning out git changes if your project generates those."
  (( verbose == 1 )) && echo "Options:"
  (( verbose == 1 )) && echo "  --clean-git, -cg: clean out git files"
  (( verbose == 1 )) && echo "  --verbose, -v: enable verbose output"
  (( verbose == 1 )) && echo "  --help, -h: show this help message"
  exit 1
fi


DIR=`pwd`
NAME=`basename ${DIR}`
(( verbose == 1 )) && echo "Docker name prefix: ${NAME}"

(( verbose == 1 )) && echo -n "Running: docker compose down..."
docker compose down
(( verbose == 1 )) && echo "done."

volumes=$(docker volume ls -q --filter name=${NAME})
if [ -z "$volumes" ]; then
  (( verbose == 1 )) && echo "No volumes to remove."
else
  (( verbose == 1 )) && echo -n "Removing volumes: $volumes"
  docker volume rm $(docker volume ls -q --filter name=${NAME})
  (( verbose == 1 )) && echo "done."
fi

(( verbose == 1 )) && echo -n "Running: docker network rm..."
docker network rm ${NAME}_default
(( verbose == 1 )) && echo "done."

(( verbose == 1 )) && echo -n "Running: docker image rm..."
docker image rm ${NAME}-web
(( verbose == 1 )) && echo "done."

if [ $clean_git -eq 1 ]; then
  (( verbose == 1 )) && echo -n "Cleaning out git..."
  git clean -ffdx
  (( verbose == 1 )) && echo "done."
fi

(( verbose == 1 )) && echo -n "Running: docker compose build..."
docker compose build
(( verbose == 1 )) && echo "done."

