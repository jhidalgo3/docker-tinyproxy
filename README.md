Docker Tinyproxy
================

> Docker implementation of [TinyProxy](https://github.com/jhidalgo3/docker-tinyproxy)

> Docker Image [tinyproxy](https://hub.docker.com/repository/docker/jhidalgo3/tinyproxy)

## Getting started

For testing purpose, you may want to change the **tinyproxy.conf** and switch the **LogLevel** value to **Info** and comment the Allow line.

```
# build docker image
docker build -t jhidalgo3/tinyproxy .

# run container in background
docker run -d --name tinyproxy -e UPSTREAM='upstream http 192.168.2.8:3128 \".com\"' -p 8888:8888 jhidalgo3/tinyproxy


# proxy request via the running container
http_proxy=127.0.0.1:8888 https_proxy=127.0.0.1:8888 curl https://www.google.com -v

# or
curl -x 127.0.0.1:8888 curl https://www.google.com -v

# or proxy all requests from linux based containers
docker run -t -i \
  -e "http_proxy=tinyproxy:8888" \
  -e "https_proxy=tinyproxy:8888" \
  --link tinyproxy \
  travix/toolbox \
  curl https://www.google.com
```

## Custom Tinyproxy configuration

```
docker run -t -i \
  -v $(pwd)/tinyxproxy.conf:/etc/tinyproxy.conf
  -p 8888:8888 \
  tinyproxy
```

## License

MIT © [Jose Maria Hidalgo Garcia](https://github.com/jhidalgo3/)
