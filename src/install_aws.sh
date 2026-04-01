#!/bin/bash
# See: https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/getting-started-install.html

set -eu

readonly BIN_DIR=~/.local/bin
readonly INSTALL_DIR=~/.local/aws-cli

# Check required commands
for cmd in curl unzip; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    printf "[ERROR] Required command '%s' not found. Please install it.\n" "$cmd" >&2
    exit 1
  fi
done

# Automatically set --update flag if AWS CLI is already installed
update_flag=""
if [ -d $INSTALL_DIR ]; then
  printf "[INFO] Existing installation found. Updating...\n"
  update_flag="--update"
else
  printf "[INFO] Installing AWS CLI v2...\n"
fi

# Create a temporary working directory
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

# Download
printf "[INFO] Downloading AWS CLI v2...\n"
curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "$tmpdir/awscliv2.zip"

# Extract the ZIP file
printf "[INFO] Extracting...\n"
unzip -q "$tmpdir/awscliv2.zip" -d "$tmpdir"

# Run the installer
printf "[INFO] Running installer...\n"
"$tmpdir/aws/install" --bin-dir "$BIN_DIR" --install-dir $INSTALL_DIR $update_flag

printf "[INFO] Done. %s\n" "$(aws --version)"
