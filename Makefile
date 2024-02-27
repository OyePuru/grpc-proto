generate-stubs:
		rm -rf gen
		mkdir -p gen/go
		protoc -I . \
		--go_out ./gen/go \
		--go_opt paths=source_relative \
		--go-grpc_out ./gen/go \
		--go-grpc_opt paths=source_relative \
		--grpc-gateway_out ./gen/go \
		--grpc-gateway_opt paths=source_relative \
		--grpc-gateway_opt grpc_api_configuration=service.yaml \
		./proto/**/*.proto
