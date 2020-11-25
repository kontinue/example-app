## example-app

A sample app that just connects to a `redis` instance and serves the result of
redis' `INFO` command on any endpoint.

### usage

#### kubernetes

To run the app in Kubernetes, submit the Kubernetes objects described in
[`config/release.yaml`](./config/release.yaml).

The following objects will be submited:


```
Namespace  Name             Kind            Owner  Conds.  Rs  Ri  Age
(cluster)  app              Deployment      -      -       -   -   -
^          app              Service         -      -       -   -   -
^          app-redis        Deployment      -      -       -   -   -
^          app-redis        Service         -      -       -   -   -
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


ps.: the deployments specify no ServiceAccounts. Depending on the Kubernetes
cluster you're targetting, you _might_ have to allow the default service
account of the namespace you're deploying into to use pod security policies.

For instance, on TKG:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: default-sa-restricted-psp
roleRef:
  kind: ClusterRole
  name: psp:vmware-system-restricted
  apiGroup: rbac.authorization.k8s.io
subjects:
  - kind: ServiceAccount
    name: default
```


#### local

1. build the app

```console
$ go build -v -i
gitlab.eng.vmware.com/tanzu-delivery-pipeline/example-app
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

