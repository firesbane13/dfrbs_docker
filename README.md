# docker-scripts

## Reverse Proxy

ProxyPreserveHost on
ProxyPass /test http://127.0.0.1:8081/
ProxyPassReverse /test http://127.0.0.1:8081/

