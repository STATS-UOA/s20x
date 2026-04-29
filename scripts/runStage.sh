#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 STAGE [DOWNLOADS_DIR]"
  echo "Example: $0 5"
  echo "Example: $0 7_1"
  echo "Example: $0 s20x_stage7_1"
  echo "Example: $0 run_s20x_stage7_1.sh /c/Users/james/Downloads"
  echo ""
  echo "This runs run_s20x_stageSTAGE.sh with s20x_stageSTAGE_changes.zip."
}

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  usage
  exit 1
fi

stageInput="$1"
stage="$stageInput"

stage="${stage##*/}"
stage="${stage%.sh}"

if [[ "$stage" == run_s20x_stage* ]]; then
  stage="${stage#run_s20x_stage}"
elif [[ "$stage" == s20x_stage* ]]; then
  stage="${stage#s20x_stage}"
elif [[ "$stage" == run_stage* ]]; then
  stage="${stage#run_stage}"
elif [[ "$stage" == stage* ]]; then
  stage="${stage#stage}"
fi

stage="${stage//./_}"

if [[ ! "$stage" =~ ^[0-9]+(_[0-9]+)?$ ]]; then
  echo "Stage must be a stage number or an s20x-prefixed stage name; got: $stageInput"
  echo "Use forms such as 7, 7_1, s20x_stage7_1, or run_s20x_stage7_1.sh."
  exit 1
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

bash "$scriptPath" --install-files --changes-zip "$changesZip"
