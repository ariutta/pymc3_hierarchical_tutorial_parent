#!/usr/bin/env bash

# see https://stackoverflow.com/a/246128/5354298
get_script_dir() { echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"; }
SCRIPT_DIR=$(get_script_dir)

OUTPUT_FILE="abcedf.txt"

pid1=""
pid2=""

cleanup() {
  echo 'Cleaning up...'
  if [[ -f "$OUTPUT_FILE" ]]; then
    rm "$OUTPUT_FILE"
  fi
  kill -9 "$pid1"
  kill -9 "$pid2"
  #ssh nixos.gladstone.internal -tt 'cd ~/Documents/pymc3_hierarchical_tutorial; nix-shell; jupyter notebook stop'
  #for mypid in $(ps | grep "ssh.*pymc" | awk '{print $1}'); do kill -9 $mypid; done
}

# Based on http://linuxcommand.org/lc3_wss0140.php
# and https://codeinthehole.com/tips/bash-error-reporting/
PROGNAME=$(basename $0)
error_exit() {
#	----------------------------------------------------------------
#	Function for exit due to fatal program error
#		Accepts 1 argument:
#			string containing descriptive error message
#	----------------------------------------------------------------


  #echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
  if [ ! "$1" ]; then
    echo "${PROGNAME}: Unknown Error" 1>&2
    read line file <<<$(caller)
    echo "An error occurred in line $line of file $file:" 1>&2
    sed "${line}q;d" "$file" 1>&2
  else
    echo "${PROGNAME}: $1" 1>&2
  fi

  cleanup
  exit 1
}

trap error_exit ERR
trap cleanup EXIT INT QUIT TERM

nohup ssh nixos.gladstone.internal -tt 'cd ~/Documents/pymc3_hierarchical_tutorial; nix-shell' > "$OUTPUT_FILE" &
pid1=$(echo $!)
sleep 3

nohup ssh -N -L 8888:localhost:8888 nixos.gladstone.internal > /dev/null &
pid2=$(echo $!)
sleep 3

open $(grep "^\s*http" "$OUTPUT_FILE" | head -n 1 | sed 's/^ *http/http/')
if [[ -f "$OUTPUT_FILE" ]]; then
  rm "$OUTPUT_FILE"
fi

echo "Hit Enter to quit"
read varname
