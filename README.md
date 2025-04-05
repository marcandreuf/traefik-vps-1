# traefik-vps-1
Traefik configuration reverse proxy for vps 1

# Staging

## Local staging
For testing the docker compose traefik configurations.

>[!IMPORTANT]
> The staging environment is used for testing dock
> Activate staging ca server in the `docker/traefik/traefik.yml`
> The log level to DEBUG
> !!Do not use this configuration in production.


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


# Production

## Deployment

1. Prod traefik config.
- Uncomment the required log level info or debug.
- Uncomment the line `caServer: https://acme-v02.api.letsencrypt.org/directory` at the `docker/traefik/traefik.yml` file.

2. Deploy the code to the VPS.
```bash
# This script requires Var Envs defined in the script.
./deploy/deploy-sync.sh
```

3. Run the docker compose command 
```bash
# Connect to the server
ssh ubuntu@$TRAEFIK_SERVER_IP -p51337
# Copy the .env.dist file to the server and edit accordingly with the prod configuration

docker compose -f docker/docker-compose.prod.yml up -d

docker compose -f docker/docker-compose.prod.yml down

```


4. Monitor traefik logs.

```bash
# Check traefik logs
docker logs --follow ${APP}-prod-reverse-proxy-container 
```

## Traefik dashboard secure access

```bash
# First get the ip address of the container running in the server
# Usually 172.18.0.2 or 172.18.0.3

ssh -p 51337 -i ~/.ssh/id_ed25519.pub ubuntu@$TRAEFIK_SERVER_IP "docker inspect $APP-prod-reverse-proxy-container | grep '\"IPAddress\": \"172\"'"

# Forward the container port to our localhost 8092. 
# We can not open ports in the docker compose because it would 
# override the ufw firewall rules and open the ports on the VPS. 

ssh -L 8090:172.{x.y.z}:80 8443:172.{x.y.z}:443 ubuntu@$TRAEFIK_SERVER_IP -51337


```

