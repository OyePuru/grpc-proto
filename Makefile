REPO_URL := https://github.com/OyePuru/grpc-proto
BRANCH := master
PROTO_FOLDER := proto
GEN_FOLDER := gen
SERVICE_YAML := service.yaml

generate-stubs-server:
	rm -rf gen/go/server
	mkdir -p gen/go/server
	protoc -I . \
	--go_out ./gen/go/server/ \
	--go_opt paths=source_relative \
	--go-grpc_out ./gen/go/server/ \
	--go-grpc_opt paths=source_relative \
	proto/**/*.proto

generate-stubs-client:
	rm -rf gen/go/client
	mkdir -p gen/go/client
	protoc -I . \
	--go_out ./gen/go/client/ \
	--go_opt paths=source_relative \
	--go-grpc_out ./gen/go/client/ \
	--go-grpc_opt paths=source_relative \
	--grpc-gateway_out ./gen/go/client \
	--grpc-gateway_opt paths=source_relative \
	--grpc-gateway_opt grpc_api_configuration=service.yaml \
	./proto/**/*.proto
