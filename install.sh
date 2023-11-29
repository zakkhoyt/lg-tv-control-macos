#!/bin/bash

SCRIPT_DIR=$(realpath "$(dirname "$0")")
echo "SCRIPT_DIR: $SCRIPT_DIR"

# source "$HOME/opt/lgtv/bin/activate"

# cp "$SCRIPT_DIR/../lgtv_init.lua" "$HOME/.hammerspoon/init.lua"
cp "$SCRIPT_DIR/lgtv_init.lua" "$HOME/.hammerspoon/init.lua"
