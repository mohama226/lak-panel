#!/usr/bin/env bash

set -Eeuo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

FRONTEND_DIR="$BASE_DIR/frontend"

echo "=================================="
echo " Building L-Panel Frontend"
echo "=================================="


if [ ! -d "$FRONTEND_DIR" ]; then

    echo "Frontend directory not found:"
    echo "$FRONTEND_DIR"

    exit 1

fi


cd "$FRONTEND_DIR"


if [ ! -d "node_modules" ]; then

    echo "Installing dependencies..."

    npm install

fi


echo
echo "Running production build..."
echo


npm run build


if [ ! -d "dist" ]; then

    echo "Build failed. dist directory not found."

    exit 1

fi


echo
echo "=================================="
echo " Frontend Build Completed"
echo "=================================="

echo
echo "Output:"
echo "$FRONTEND_DIR/dist"
