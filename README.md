# docker-scripts

## Reverse Proxy

### Apache reverse proxy

ProxyPreserveHost on
ProxyPass /test http://127.0.0.1:8081/
ProxyPassReverse /test http://127.0.0.1:8081/

### ngnix reverse proxy

docker pull jwilder/nginx-proxy

Run ngnix reverse proxy:
docker run -d -p 80:80 -p 443:443 -v /var/run/docker.sock:/tmp/docker.sock -t jwilder/nginx-proxy

## Docker Commands

### Build Images
sudo docker build -t <docker_image_tag> .

### Run Image
-d: detached
-t: tty (Keeps container alive)
-p: port mapping

// sudo docker run -d -t -p <host_port>:80 <docker_image_tag>
//
// Ex. sudo docker -D run -d -t -p 8083:80 docker_test

// Create network bridge
docker network create -d bridge <bridge_name> \
    --opt com.docker.network.bridge.default_bridge=true \
    --opt com.docker.network.bridge.enable_icc=true \
    --opt com.docker.network.bridge.host_binding_ipv4=0.0.0.0 \
    --opt com.docker.network.bridge.name=<bridge_name> \
    --opt com.docker.network.driver.mtu=1500

Ex.
docker network create -d bridge sso_bridge \
    --opt com.docker.network.bridge.default_bridge=true \
    --opt com.docker.network.bridge.enable_icc=true \
    --opt com.docker.network.bridge.host_binding_ipv4=0.0.0.0 \
    --opt com.docker.network.bridge.name=sso_bridge \
    --opt com.docker.network.driver.mtu=1500

// Run in project root directory
docker run --rm --network=<bridge_name> --name=<server_name> -e VIRTUAL_HOST=<desired_url> -d --mount type=bind,source="$(pwd)",target=/var/www/html/site <docker_image>

Ex. docker run --rm --network=sso_bridge --name=docker-test -e VIRTUAL_HOST=docker-test.mocodev.local -d --mount type=bind,source="$(pwd)",target=/var/www/html/site ae7eeadd8cd0

### Clean up exited containers
docker ps --filter "status=exited" | grep 'weeks ago' | awk '{print $1}' | xargs --no-run-if-empty docker rm

### Docker build

docker build .

### Connect to Docker Container
docker exec -it <container_id> /bin/bash

### Docker Remove All Containers

docker rm $(docker ps -a -q)

### Docker Remove All Images

docker rmi $(docker images -a -q)
