#!/bin/zsh

# Check if an argument is passed
if [ -z "$1" ]; then
  echo "Usage: $0 <package_name>"
  exit 1
fi

# Assign the argument to a variable
PACKAGE_NAME=$1

# Run the command with the updated argument
supra move tool init --package-dir /supra/configs/move_workspace/dextr-contracts-move/"$PACKAGE_NAME" --name "$PACKAGE_NAME"