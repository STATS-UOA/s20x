#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 STAGE [DOWNLOADS_DIR]"
  echo "Example: $0 16.1"
  echo "Example: $0 16_1"
  echo "Example: $0 run_s20x_stage16.1.sh"
  echo "Example: $0 16.1 ~/Downloads"
  echo ""
  echo "This runs run_s20x_stageSTAGE.sh with s20x_stageSTAGE_change_set.zip."
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

stageDot="${stage//_/.}"
stageUnderscore="${stage//./_}"

if [[ ! "$stageDot" =~ ^[0-9]+(\.[0-9]+)*$ ]]; then
  echo "Stage must be a stage number or an s20x-prefixed stage name; got: $stageInput"
  echo "Use forms such as 16.1, 16_1, s20x_stage16.1, or run_s20x_stage16.1.sh."
  exit 1
fi

if [ $# -eq 2 ]; then
  downloadsDir="$2"
elif [ -d "$HOME/Downloads" ]; then
  downloadsDir="$HOME/Downloads"
elif [[ "$(uname -s)" == "Darwin" ]]; then
  downloadsDir="$HOME/Downloads"
else
  downloadsDir="/c/Users/james/Downloads"
fi

scriptCandidates=(
  "${downloadsDir}/run_s20x_stage${stageDot}.sh"
  "${downloadsDir}/run_s20x_stage${stageUnderscore}.sh"
)

zipCandidates=(
  "${downloadsDir}/s20x_stage${stageDot}_change_set.zip"
  "${downloadsDir}/s20x_stage${stageUnderscore}_change_set.zip"
  "${downloadsDir}/s20x_stage${stageDot}_changes.zip"
  "${downloadsDir}/s20x_stage${stageUnderscore}_changes.zip"
)

scriptPath=""
for candidate in "${scriptCandidates[@]}"; do
  if [ -f "$candidate" ]; then
    scriptPath="$candidate"
    break
  fi
done

if [ -z "$scriptPath" ]; then
  echo "Cannot find stage script. Tried:"
  printf '  %s\n' "${scriptCandidates[@]}"
  exit 1
fi

changesZip=""
for candidate in "${zipCandidates[@]}"; do
  if [ -f "$candidate" ]; then
    changesZip="$candidate"
    break
  fi
done

if [ -z "$changesZip" ]; then
  echo "Cannot find change-set zip. Tried:"
  printf '  %s\n' "${zipCandidates[@]}"
  exit 1
fi

bash "$scriptPath" --install-files "$changesZip"
