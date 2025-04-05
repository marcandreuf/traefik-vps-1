#!/bin/bash

# Deploy script to sync files from local to remote server
# This script is used to sync files from local to remote server using rsync
# It uses ssh to connect to the remote server and rsync to sync the files
# It excludes some files and directories from the sync process
# It requires the following environment variables to be set:
# - TRAEFIK_SERVER_IP: The IP address of the remote server. setup it up in the docker/.env file


echo "RSync files from local to remote"

REVPROXY_DIR="/home/ubuntu/revproxy"

ssh -p 51337 -i ~/.ssh/id_ed25519.pub ubuntu@$TRAEFIK_SERVER_IP "[ ! -d $REVPROXY_DIR ] && mkdir -p $REVPROXY_DIR && echo 'Reverse proxy directory created' || echo 'Directory $REVPROXY_DIR already exists'"

rsync -zarvhC --relative --no-perms --no-owner --no-group \
 -e "ssh -p 51337 -i ~/.ssh/id_ed25519.pub" \
 --exclude='docker/traefik/logs/*.*' \
 --exclude='docker/traefik/acme.json' \
 --exclude='docker/traefik/secrets/' \
 --exclude='docker/.env' \
   ./docker/docker-compose.prod.yml \
   ./docker/traefik/ \
   ubuntu@$TRAEFIK_SERVER_IP:/home/ubuntu/revproxy

echo "Files synched"