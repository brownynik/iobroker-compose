#!/bin/sh

CFG_FOLDER=/mnt/hdd
export CFG_FOLDER
docker-compose -f $CFG_FOLDER/portainer-compose.yaml -p portainer up -d
