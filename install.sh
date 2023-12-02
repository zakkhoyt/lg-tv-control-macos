#!/bin/bash



SCRIPT_DIR=$(realpath "$(dirname "$0")")
echo "SCRIPT_DIR: $SCRIPT_DIR"

# source "$HOME/opt/lgtv/bin/activate"

# cp "$SCRIPT_DIR/../lgtv_init.lua" "$HOME/.hammerspoon/init.lua"
# cp "$SCRIPT_DIR/lgtv_init.lua" "$HOME/.hammerspoon/init.lua"

SPOONS_DIR="$HOME/.hammerspoon/Spoons"

if [[ "$1" == "dev" ]]; then
  cp "$SCRIPT_DIR/dev_init.lua" "$HOME/.hammerspoon/init.lua"
elif [[ "$1" == "spoon" ]]; then
  LGTV_SPOON_DIR="$SCRIPT_DIR/LGTVMonitor.spoon"

  # Create spoon documentation
  # shellcheck disable=SC2164
  pushd "$LGTV_SPOON_DIR"
  hs -c "hs.doc.builder.genJSON(\"$(pwd)\")" | jq  > docs.json
  # shellcheck disable=SC2164

  # Ensure spoons dir exists
  mkdir -p "$SPOONS_DIR"
  cp -R "$LGTV_SPOON_DIR" "$SPOONS_DIR"
else 
  cp "$SCRIPT_DIR/lgtv_init.lua" "$HOME/.hammerspoon/init.lua"
fi