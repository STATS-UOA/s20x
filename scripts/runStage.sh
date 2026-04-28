#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 STAGE [DOWNLOADS_DIR]"
  echo "Example: $0 4"
  echo "Example: $0 4 /c/Users/james/Downloads"
  echo ""
  echo "This runs run_s20x_stageSTAGE.sh with s20x_stageSTAGE_changes.zip."
}

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  usage
  exit 1
fi

stage="$1"

if [[ "$stage" == s20x_stage* ]]; then
  stage="${stage#s20x_stage}"
elif [[ "$stage" == stage* ]]; then
  stage="${stage#stage}"
fi

if [ $# -eq 2 ]; then
  downloadsDir="$2"
elif [[ "$(uname -s)" == "Darwin" ]]; then
  downloadsDir="$HOME/Downloads"
else
  downloadsDir="/c/Users/james/Downloads"
fi

scriptPath="${downloadsDir}/run_s20x_stage${stage}.sh"
changesZip="${downloadsDir}/s20x_stage${stage}_changes.zip"

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
