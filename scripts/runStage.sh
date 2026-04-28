#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 STAGE [DOWNLOADS_DIR]"
  echo "Example: $0 7_2"
  echo "Example: $0 7_2 /c/Users/james/Downloads"
}

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  usage
  exit 1
fi

stage="$1"

if [ $# -eq 2 ]; then
  downloadsDir="$2"
elif [[ "$(uname -s)" == "Darwin" ]]; then
  downloadsDir="$HOME/Downloads"
else
  downloadsDir="/c/Users/james/Downloads"
fi

scriptPath="${downloadsDir}/run_stage${stage}.sh"
changesZip="${downloadsDir}/stage${stage}_changes.zip"

if [ ! -f "$scriptPath" ]; then
  echo "Cannot find script: $scriptPath"
  exit 1
fi

if [ ! -f "$changesZip" ]; then
  echo "Cannot find changes zip: $changesZip"
  exit 1
fi

chmod +x "$scriptPath"
"$scriptPath" -if -cz "$changesZip"
