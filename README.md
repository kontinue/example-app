## example

This example demonstrates how one could run unit tests, build a container image,
and run an "end-to-end" of an example app leveraging Kontinue as the engine to
figure out when to run those steps as well as orchestrate the passing of
variables between them.


```

  unit tests  -->
    (tekton) 

        build container image --> 
               (kpack)                


                  deploy application  -->
                         and redis
                      (deployment+service)                


                               integration test -->
                                 (tekton)       

                                          teardown
                                      (remove app + dependencies)

```

### Prequisites

This example assumes that the following are already installed in the Kubernetes cluster:

- [`kontinue`]
- [`kpack`]
- [`tekton`]

The last two (`kpack` and tekton`) can be installed as follows:

```console
$ kubectl apply \
    -f https://storage.googleapis.com/tekton-releases/pipeline/previous/v0.15.0/release.yaml \
    -f https://github.com/pivotal/kpack/releases/download/v0.0.9/release-0.0.9.yaml
```

For `kontinue`, checkout the docs at [`kontinue/crds`].


### Running

Create a [`Secret`] that contains the username and password to the container
image registry that [`kpack`] should push images to:

```console
$ kubectl create secret generic \
    registry-credentials \
      --type kubernetes.io/basic-auth \
      --from-literal username=$DOCKERHUB_USERNAME \
      --from-literal password=$DOCKERHUB_PASSWORD

$ kubectl annotate secret \
    registry-credentials \
    build.pivotal.io/docker=https://index.docker.io/v1/
```

*(replace `$DOCKERHUB_` with your own credentials)*


[`Secret`]: https://kubernetes.io/docs/concepts/configuration/secret/
[`kontinue`]: https://github.com/kontinue/crds
[`kpack`]: https://github.com/pivotal/kpack
[`tekton`]: https://github.com/tektoncd/pipeline
