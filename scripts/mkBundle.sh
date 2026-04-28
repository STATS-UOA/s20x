#!/usr/bin/env bash
set -euo pipefail

if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
  echo "Do not source this script. Run it with: bash ${BASH_SOURCE[0]}"
  return 1 2>/dev/null || exit 1
fi

stage="${1:-}"
base_ref="${2:-HEAD}"
output_dir="${3:-chatgpt-bundles}"

if [[ -z "$stage" ]]; then
  echo "Usage: bash scripts/mkBundle.sh STAGE [BASE_REF] [OUTPUT_DIR]"
  echo "Example: bash scripts/mkBundle.sh 12.8"
  echo "Example: bash scripts/mkBundle.sh 12.8 HEAD chatgpt-bundles"
  exit 1
fi

Rscript scripts/makeChatgptBundle.R --stage "$stage" --base "$base_ref" --output-dir "$output_dir"
