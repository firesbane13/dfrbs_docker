# docker-scripts

## Reverse Proxy

### Apache reverse proxy

I'm more familiar with Apache so started down the route of using Apache.   I already had a LAMP stack
setup.  What I discovered what I could setup a "reverse" proxy using the Proxy commands, but
I had to define it for each new docker container.   I didn't want to have to have this manual step
in there.   So I decided to use the ngnix container below.   Sometime later, I'll create my own
setup/container for the ngnix reverse proxy.  I'm noting the Apache commands I learned here.

ProxyPreserveHost on
ProxyPass /test http://127.0.0.1:8081/
ProxyPassReverse /test http://127.0.0.1:8081/

### ngnix reverse proxy

As mentioned above, I decided to use the ngnix reverse proxy

docker pull jwilder/nginx-proxy

Run ngnix reverse proxy:
    docker run --rm -d -p 80:80 -p 443:443 -v /var/run/docker.sock:/tmp/docker.sock -t jwilder/nginx-proxy

## Docker Commands

### Build Images
docker build -t <docker_image_tag> .

### Run Image

// OLD Commands:
// -d: detached
// -t: tty (Keeps container alive)
// -p: port mapping
//
// sudo docker run -d -t -p <host_port>:80 <docker_image_tag>
//
// Ex. sudo docker -D run -d -t -p 8083:80 docker_test

// Run in project root directory
docker run --rm --add-host="<server_url>:<ip>" --name=<container_name> -e VIRTUAL_HOST=<desired_url> -d --mount type=bind,source="$(pwd)",target=/var/www/html/site <docker_image>

Ex. docker run --rm --add-host="test.server.com:192.168.0.101" --name=docker-test -e VIRTUAL_HOST=docker-test.mocodev.local -d --mount type=bind,source="$(pwd)",target=/var/www/html/site ae7eeadd8cd0

### Connect to Docker Container

docker exec -it <container_id> /bin/bash

### Docker Remove All Containers

docker rm $(docker ps -a -q)

#### Clean up exited containers

docker ps --filter "status=exited" | grep 'weeks ago' | awk '{print $1}' | xargs --no-run-if-empty docker rm

### Docker Remove All Images

docker rmi $(docker images -a -q)

### Docker List Network Configuration

docker network inspect <network_name>

Ex.
    docker network inspect bridge
