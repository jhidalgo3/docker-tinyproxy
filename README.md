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

## K8S Installation

```
kubectl create ns proxy
```

Change your Proxy configuration (_[USERNAME:PASS@PROXY_HOST:PORT]_) into ./k8s/deployment_tinyproxy.yaml.

Install tinyproxy pod and service:

```
kubectl -f ./k8s/deployment_tinyproxy.yaml
```

Check Service

```
kubectl get svc -n proxy

NAME        TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE
tinyproxy   ClusterIP   10.24.12.62   <none>        8888/TCP   1h
```

Install pod curl testing
```
kubectl -f ./k8s/k8s/pod_curl-test.yaml
```

Testing
```
kubectl exec -it -n proxy curl-test -c curl -- sh -c "curl http://httpbin.org/headers"


{
  "headers": {
    "Accept": "*/*",
    "Cache-Control": "max-age=259200",
    "Host": "httpbin.org",
    "If-Modified-Since": "Thu, 27 May 2021 16:01:14 GMT",
    "User-Agent": "curl/7.68.0",
    "X-Amzn-Trace-Id": "Root=1-60b0ef4a-6bc5100e3fed2a5b50213277"
  }
}
```


## License

MIT © [Jose Maria Hidalgo Garcia](https://github.com/jhidalgo3/)
