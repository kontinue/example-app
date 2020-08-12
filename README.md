## example-app

A sample app that just connects to a `redis` instance and serves the result of
redis' `INFO` command on any endpoint.

### usage

#### local

1. build the app

```console
$ go build -v -i
github.com/kontinue/example-app
```

2. run redis

```console
$ docker run --name redis -d -p 6379:6379 redis

$ docker exec redis redis-cli PING
PING
PONG
```

3. run it

```console
$ ./example-app
Starting up {RedisAddr:127.0.0.1:6379 Addr:0.0.0.0:8080}
```

4. check that it works

*(in another terminal)*

```console
$ curl localhost:8080
Server
  redis_version:6.0.6
  redis_git_sha1:00000000
  redis_git_dirty:0
  redis_build_id:19d4277f1e8a2fed
```


#### kubernetes

To run the app in Kubernetes, submit the Kubernetes objects described in
[`./k8s.yaml`](./k8s.yaml).

The following objects will be submited:


```
  NAMESPACE     NAME      KIND      
  (default)     app       Deployment
  ^             app       Service   
  ^             redis     Deployment
  ^             redis     Service   
```

To reach the app from your machine, `port-forward` the app's port:

```console
$ kubectl port-forward service/app 8080:8080
 Forwarding from 127.0.0.1:8080 -> 8080
 Forwarding from [::1]:8080 -> 8080
```

Then, in another terminal, make a request to it:

```console
$ curl localhost:8080
Server
  redis_version:6.0.6
  redis_git_sha1:00000000
  redis_git_dirty:0
  redis_build_id:19d4277f1e8a2fed
```

