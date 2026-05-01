#!/usr/bin/env bash
set -euo pipefail

keepCount="${1:-1}"

if ! [[ "$keepCount" =~ ^[1-9][0-9]*$ ]]; then
  echo "Usage: $0 [number_to_keep]"
  exit 1
fi

scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

find "$scriptDir" -maxdepth 1 -type f -name "*_completed.zip" -print |
  while IFS= read -r file; do
    stat -f "%m %N" "$file"
  done |
  sort -rn |
  awk -v keepCount="$keepCount" 'NR > keepCount {sub(/^[0-9]+ /, ""); print}' |
  while IFS= read -r file; do
    rm -f "$file"
    echo "Removed $file"
  done