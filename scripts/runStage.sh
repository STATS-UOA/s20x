#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 STAGE [DOWNLOADS_DIR] [-sn N|--start-step-number N]"
  echo "Example: $0 16.1"
  echo "Example: $0 16_1"
  echo "Example: $0 run_s20x_stage16.1.sh"
  echo "Example: $0 16.1 ~/Downloads"
  echo "Example: $0 18.1 -sn 8"
  echo "Example: $0 18.1 ~/Downloads --start-step-number 8"
  echo ""
  echo "This runs run_s20x_stageSTAGE.sh with s20x_stageSTAGE_change_set.zip."
  echo "The -sn/--start-step-number option is forwarded to the stage runner."
}

if [ $# -lt 1 ]; then
  usage
  exit 1
fi

stageInput="$1"
shift

startStepNumber=""
downloadsDir=""

while [ $# -gt 0 ]; do
  case "$1" in
    -sn|--start-step-number)
      if [ $# -lt 2 ]; then
        echo "Missing value for $1"
        usage
        exit 1
      fi
      startStepNumber="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -* )
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
    *)
      if [ -n "$downloadsDir" ]; then
        echo "Unexpected extra argument: $1"
        usage
        exit 1
      fi
      downloadsDir="$1"
      shift
      ;;
  esac
done

if [ -n "$startStepNumber" ] && [[ ! "$startStepNumber" =~ ^[0-9]+$ ]]; then
  echo "Start step number must be a positive integer; got: $startStepNumber"
  exit 1
fi

if [ -n "$startStepNumber" ] && [ "$startStepNumber" -lt 1 ]; then
  echo "Start step number must be a positive integer; got: $startStepNumber"
  exit 1
fi

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

if [ -z "$downloadsDir" ]; then
  if [ -d "$HOME/Downloads" ]; then
    downloadsDir="$HOME/Downloads"
  elif [[ "$(uname -s)" == "Darwin" ]]; then
    downloadsDir="$HOME/Downloads"
  else
    downloadsDir="/c/Users/james/Downloads"
  fi
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

runnerArgs=(--install-files "$changesZip")

if [ -n "$startStepNumber" ]; then
  runnerArgs+=(--start-step-number "$startStepNumber")
fi

bash "$scriptPath" "${runnerArgs[@]}"
