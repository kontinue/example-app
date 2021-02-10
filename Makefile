REGISTRY ?= kontinue

build:
	go build -v -i

test:
	go test -v


image-docker:
	docker build -t $(REGISTRY)/example-app .
image-pack:
	pack build $(REGISTRY)/example-app
push-image:
	docker push $(REGISTRY)/example-app


deploy:
	kapp deploy -c -a example-app -f .
delete:
	kapp delete -a example-app


gen-release:
	ytt -f ./config/values.yaml -f ./config/bases > ./config/release.yaml
