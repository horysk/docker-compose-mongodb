#!/bin/bash
#set -x
set -eo pipefail
shopt -s nullglob

#docker-compose down
docker-compose stop mongoos
docker-compose stop configsrv
docker-compose stop shdmongodb
