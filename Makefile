# Variables
PROTO_FILES := $(shell find . -name "*.proto")

.PHONY: gen clean

gen:
	protoc --proto_path=. \
		--go_out=. --go_opt=paths=source_relative \
		--go-grpc_out=. --go-grpc_opt=paths=source_relative \
		$(PROTO_FILES)

clean:
	find . -name "*.pb.go" -type f -delete
	find . -name "*_grpc.pb.go" -type f -delete