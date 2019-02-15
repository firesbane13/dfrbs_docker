# docker-scripts

## Reverse Proxy

ProxyPreserveHost on
ProxyPass /test http://127.0.0.1:8081/
ProxyPassReverse /test http://127.0.0.1:8081/

### ngnix reverse proxy

docker pull jwilder/nginx-proxy

## Docker Commands

### Build Images
sudo docker build -t <docker_image_tag> .

### Run Image
-d: detached
-t: tty (Keeps container alive)
-p: port mapping

sudo docker run -d -t -p <host_port>:80 <docker_image_tag>

Ex. sudo docker -D run -d -t -p 8083:80 docker_test

### Clean up exited containers
docker ps --filter "status=exited" | grep 'weeks ago' | awk '{print $1}' | xargs --no-run-if-empty docker rm


