generate-stubs-go:
	@echo "Cleaning up..."
	@rm -rf gen/go
	@echo "Generating stubs..."

	# Loop through files in the target directory
	@for file in ./proto/**/*.proto; do \
		basefile=$$(basename $$file .proto); \
		dir=$$(dirname $$file); \
		yaml_file=$$dir/service.yaml; \
		mkdir -p gen/go/proto; \
		echo "Processing $$file"; \
		protoc -I . \
		--go_out=./gen/go \
		--go_opt=paths=source_relative \
		--go-grpc_out=./gen/go \
		--go-grpc_opt=paths=source_relative \
		--grpc-gateway_out=./gen/go \
		--grpc-gateway_opt=paths=source_relative \
		--grpc-gateway_opt=grpc_api_configuration=$$yaml_file \
		$$file; \
	done
	@echo "Stubs generation completed."

generate-stubs-ts:
	@echo "Cleaning up..."
	@rm -rf gen/ts
	@echo "Generating stubs..."

	# Loop through files in the target directory
	@find ./proto/**/ -name "*.proto" | while read -r file; do \
		basefile=$$(basename $$file .proto); \
		dir=$$(dirname $$file); \
		yaml_file=$$dir/service.yaml; \
		echo "Processing $$file $$dir"; \
		mkdir -p gen/ts/$$(dirname $$dir)/$$basefile; \
		PROTOC_GEN_TS_PATH="./node_modules/.bin/protoc-gen-ts"; \
		PROTOC_GEN_GRPC_PATH="./node_modules/.bin/grpc_tools_node_protoc_plugin"; \
		protoc \
		    --plugin="protoc-gen-ts=$$PROTOC_GEN_TS_PATH" \
		    --plugin=protoc-gen-grpc=$$PROTOC_GEN_GRPC_PATH \
		    --js_out="import_style=commonjs,binary:gen/ts" \
		    --ts_out="service=grpc-node:gen/ts" \
		    --grpc_out="gen/ts" \
		    $$file; \
	done
	@echo "Stubs generation completed."

generate-stubs-python:
	@echo "Cleaning up..."
	@rm -rf gen/python
	@echo "Generating stubs..."

	# Loop through files in the target directory
	@find ./proto -name "*.proto" | while read -r file; do \
		basefile=$$(basename $$file .proto); \
		dir=$$(dirname $$file); \
		yaml_file=$$dir/service.yaml; \
		echo "Processing $$file"; \
		mkdir -p gen/python/$$dir; \
		OUT_DIR="./gen/python"; \
		python3 -m grpc_tools.protoc \
			-I$$dir  \
			--python_out=$$OUT_DIR/$$dir \
			--pyi_out=$$OUT_DIR/$$dir \
			--grpc_python_out=$$OUT_DIR/$$dir \
			$$file; \
	done
	@find ./gen/python/proto -type f -name '*_pb2_grpc.py' -exec sh -c 'folder=$$(basename $${1%/*}); sed -i "s/import \(.*\)_pb2 as \(.*\)__/import gen.proto.$$folder.\1_pb2 as \2__/g" "$$1"' _ {} \;
	@find ./gen/python -type d -exec touch {}/__init__.py \;
	@echo "from .proto.example import example_pb2" >> ./gen/python/__init__.py
	@echo "from .proto.example import example_pb2_grpc" >> ./gen/python/__init__.py
	@echo "from .proto.person import person_pb2" >> ./gen/python/__init__.py
	@echo "from .proto.person import person_pb2_grpc" >> ./gen/python/__init__.py
	@echo "Stubs generation completed."