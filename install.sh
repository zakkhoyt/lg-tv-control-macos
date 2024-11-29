#!/bin/bash

# set -e
# set -x

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

  # # Create spoon documentation
  # # shellcheck disable=SC2164
  # pushd "$LGTV_SPOON_DIR"
  # hs -c "hs.doc.builder.genJSON(\"$(pwd)\")" | jq  > docs.json
  # # shellcheck disable=SC2164

  # Ensure spoons dir exists
  mkdir -p "$SPOONS_DIR"
  cp -R "$LGTV_SPOON_DIR" "$SPOONS_DIR"
  cp "$SCRIPT_DIR/dev_init.lua" "$HOME/.hammerspoon/init.lua"
else 
  cp "$SCRIPT_DIR/lgtv_init.lua" "$HOME/.hammerspoon/init.lua"
fi


zkill() {
  _logp_se() {
    echo "$@" 1>&2
  }

  _logp_se_d() {
    if [[ -n "$IS_DEBUG" ]]; then
      echo "$@" 1>&2
    fi
  }

  # Use the first line (consider it more accurate)
  line=$(ps aux | grep -v "grep" | grep "$1" | tr -s " " | head -n 1)
  pid=$(echo "$line" | cut -d " " -f 2)
  bin=$(echo "$line" | cut -d " " -f 11)

  _logp_se_d "line: |$line|"
  _logp_se_d "pid: '${pid}'"
  _logp_se_d "bin: '$bin'"

  if [[ -z "${pid}" ]]; then
    echo "Failed to find pid for $1"
    # return 1
  fi

  # shellcheck disable=SC2181
  _logp_se "killing $bin (${pid})..."
  _logp_se --red "kill \"${pid}\"" --default
  kill -9 "${pid}"
  RVAL=$?
  if [[ $RVAL -ne 0 ]]; then
    _logp_se "Failed to kill process: ${1} with pid: ${pid}. Kill command returned $RVAL"
    # return 2
  fi

  # Check if kill succeeded
  # pid2=$(pgrep "${pid}")
  # shellcheck disable=SC2009
  pid2=$(ps aux | grep -v "grep" | grep -o "${pid}")
  RVAL=$?
  if [[ $RVAL -ne 0 ]]; then
  # if [[ "$?" == 0 ]]; then
    _logp_se "Failed to kill process: ${1} with pid: ${pid}. Kill command returned $RVAL, but process of the sane name is still runnign: pid2: ${pid2}"
    # return 3
  else
    _logp_se "Successfully killed process: ${1} with pid: ${pid}"
  fi

  # if [[ -n "$bin" ]]; then
  #   bin2=$(echo "$bin2" | sed -E 's/(.*\.app)(.*)/\1/g')
  # else 
  #   _logp_se "Process (${pid}) could not be relaunched because no process name could be extracted."
  #   # return 1
  #   bin2="$1"
    
  # fi

  # if [[ -n "$bin" ]]; then
  #   bin2="$bin"
  # else 
    bin2="$1"
  # fi
  
  _logp_se "Will launch bin2: $bin2..."
  echo "$bin2" | grep ".app" 1> /dev/null
  if [[ $RVAL -eq 0 ]]; then
    # Is a .app command. Strip off anything after .app
    # EX: /Applications/Blender.app/Contents/MacOS/Blender -> /Applications/Blender.app
    open "$(echo "$bin2" | sed -E 's|(.*\.app)(.*)|\1|g')"
  else
    # EX 
    eval "$bin2"
  fi

  RVAL=$?
  if [[ $RVAL -eq 0 ]]; then
    : # success
    _logp_se "Successfullt relanched $bin2"
  else
    _logp_se "Failed to relaunch $bin2"
  fi
}

zkill "/Applications/Hammerspoon.app" relaunch
