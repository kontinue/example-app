build:
	go build -v -i

test:
	go test -v

image:
	pack build harbor-repo.vmware.com/tanzu_delivery_pipeline/example-app
push-image:
	docker push harbor-repo.vmware.com/tanzu_delivery_pipeline/example-app


deploy:
	kapp deploy -c -a example-app -f .
delete:
	kapp delete -a example-app


gen-release:
	ytt -f ./config/values.yaml -f ./config/bases > ./config/release.yaml
