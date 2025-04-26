#!/bin/bash -e

# Define the root directory of your project
ROOT_DIR=$(git rev-parse --show-toplevel) # Best practice, automatically finds root
PROTO_DIR="$ROOT_DIR" # In your case, the proto files are in the root

# Define output directories
GO_OUT="$ROOT_DIR"
GRPC_OUT="$ROOT_DIR"

# Function to generate proto files for a specific directory
generate_proto() {
    local proto_dir="$1"
    echo "Generating protobuf files for $proto_dir"

    # Find all .proto files in the given directory
    find "$proto_dir" -name "*.proto" | while read -r proto_file; do
        # Extract the directory relative to the root
        proto_file_dir=$(dirname "$proto_file")
        relative_dir=$(echo "$proto_file_dir" | sed "s|^$ROOT_DIR/||")

        # Generate Go code, mapping to the correct output directory
        protoc -I="$ROOT_DIR" \
            -M "$relative_dir/$proto_file=$GO_OUT/$relative_dir" \
            --go_out="$GO_OUT" --go-grpc_out="$GRPC_OUT" \
            "$proto_file"
    done
}

# Generate proto files for each directory
generate_proto "address"
generate_proto "company"
generate_proto "customer"
generate_proto "employee"

echo "Protobuf code generation complete."