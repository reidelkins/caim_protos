#!/bin/bash -e

ROOT_DIR=$(git rev-parse --show-toplevel)
PROTO_DIR="$ROOT_DIR"

GO_OUT="$ROOT_DIR"
GRPC_OUT="$ROOT_DIR"

# Function to generate proto files for a specific directory
generate_proto() {
    local proto_dir="$1"
    echo "Generating protobuf files for $proto_dir"

    find "$proto_dir" -name "*.proto" | while read -r proto_file; do
        protoc -I="$ROOT_DIR" \
            --go_out="$GO_OUT" --go_opt=paths=source_relative \
            --go-grpc_out="$GRPC_OUT" --go-grpc_opt=paths=source_relative \
            "$proto_file"
    done
}

# Generate proto files for each directory
for dir in $(find . -maxdepth 1 -type d ! -path .); do
    generate_proto "${dir#./}"
done


echo "Protobuf code generation complete."
