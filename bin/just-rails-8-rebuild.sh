#!/bin/bash
#
# clean out and rebuild the docker image
#

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
        -*)
            echo "Invalid option: $1" >&2
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

# verbose?
(( verbose == 1 )) && echo "Verbose mode enabled"

# clean-git?
if [ $clean_git -eq 1 ]; then
  (( verbose == 1 )) && echo -n "Cleaning out git..."
  git clean -fd
  (( verbose == 1 )) && echo "done."
fi

exit 0

DIR=`pwd`
NAME=`basename ${DIR}`
(( verbose == 1 )) && echo "Docker name prefix: ${NAME}"

(( verbose == 1 )) && echo -n "Running: docker compose down..."
docker compose down
(( verbose == 1 )) && echo "done."

(( verbose == 1 )) && echo -n "Running: docker volume rm..."
docker volume rm $(docker volume ls -q --filter name=${NAME})
(( verbose == 1 )) && echo "done."

(( verbose == 1 )) && echo -n "Running: docker network rm..."
docker network rm ${NAME}_default
(( verbose == 1 )) && echo "done."

(( verbose == 1 )) && echo -n "Running: docker image rm..."
docker image rm ${NAME}-web
(( verbose == 1 )) && echo "done."

(( verbose == 1 )) && echo -n "Running: docker compose build..."
docker compose build
(( verbose == 1 )) && echo "done."

