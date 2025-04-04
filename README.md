# traefik-vps-1
Traefik configuration reverse proxy for vps 1


## Local staging
For testing the docker compose traefik configurations.

>[!IMPORTANT]
> The staging environment is used for testing dock
> Activate staging ca server in the traefik/traefik.yml
> The log level to DEBUG
> Do not use this configuration in production.


```bash
# In the website project root
# Run this outside the devContainer
docker compose -f docker/docker-compose.stag.yml up
```


## Local DNS

Setup the host DNS resolver to the staging domain name

> [!IMPORTANT]
> Required for local dev

### Hosts file

Setup the hosts file to point to the sample test domain. i.e in linux add the following line to the `/etc/hosts` file.

```bash
# Get the container ip address of the traefik service.
# i.e run the command `docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}} <container_name_or_id>`

172.27.0.2  tf-dashboard.itqualab.com
```


## Production deployment

1. Prod traefik config.
- Uncomment the required log level info or debug.
- Uncomment the line `caServer: https://acme-v02.api.letsencrypt.org/directory` at the `docker/traefik/traefik.yml` file.

2. Deploy the code to the VPS.
```bash
# Copy all prod files use the script
# This script requires Var Envs defined in the script.
./deploy/deploy-sync.sh
```

3. Run the docker compose command -d
4. Monitor traefik logs. Docker logs follow ....


```bash
# First time setup.
export TRAEFIK_SERVER_IP={server ip address}
 

ssh ubuntu@$TRAEFIK_SERVER_IP -p51337
```