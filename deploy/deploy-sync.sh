echo "RSync files from local to remote"

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