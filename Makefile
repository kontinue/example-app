build:
	go build -v -i

test:
	go test -v

image:
	pack build kontinue/example-app

deploy:
	kapp deploy -c -a example-app -f .
delete:
	kapp delete -a example-app
