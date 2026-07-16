#!/bin/bash
set -e

TMP_DIR=$(mktemp -d)

echo "Downloading L-Panel..."

curl -L https://github.com/mohama226/l-panel/archive/refs/heads/main.zip \
    -o "$TMP_DIR/l-panel.zip"

echo "Extracting..."

unzip -q "$TMP_DIR/l-panel.zip" -d "$TMP_DIR"

cd "$TMP_DIR/l-panel-main"

chmod +x installer/install.sh

bash installer/install.sh

rm -rf "$TMP_DIR"
