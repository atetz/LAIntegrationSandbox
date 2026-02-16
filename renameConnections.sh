#! /bin/bash

LOCAL="./connections.local.json"
REMOTE="./connections.remote.json"
TARGET="./connections.json"

case $1 in
  local)
    echo "Setting up LOCAL environment..."
    cp "$LOCAL" "$TARGET"
    ;;
  remote)
    echo "Setting up REMOTE environment..."
    cp "$REMOTE" "$TARGET"
    ;;
  *)
    echo "Usage: $0 {local|remote}"
    exit 1
    ;;
esac

echo "Done. connections.json is now updated."