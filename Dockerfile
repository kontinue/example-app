ARG BUILDER_IMAGE=golang:1.15
ARG RUNTIME_IMAGE=gcr.io/distroless/static:nonroot

FROM $BUILDER_IMAGE as builder

	WORKDIR /workspace
	COPY    . .

	RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on \
		go build -a -v -o main


FROM $RUNTIME_IMAGE

	WORKDIR /
	COPY --from=builder /workspace/main .
	USER 65532:65532

	ENTRYPOINT ["/main"]
