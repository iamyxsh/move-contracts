#!/bin/bash


if [ -z "$1" ]; then
  echo "Usage: $0 <package_name>"
  exit 1
fi

PACKAGE_NAME=$1

docker exec -it supra_cli /supra/supra move tool compile --package-dir /supra/configs/move_workspace/dextr-contracts-move/"$PACKAGE_NAME"