#!/usr/bin/env bash
set -euo pipefail

keepCount="${1:-1}"

if ! [[ "$keepCount" =~ ^[1-9][0-9]*$ ]]; then
  echo "Usage: $0 [number_to_keep]"
  exit 1
fi

scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
bundleDir="$scriptDir/chatgpt-bundles"

if [[ ! -d "$bundleDir" ]]; then
  echo "No chatgpt-bundles directory found."
  exit 0
fi

fileMtime() {
  local file="$1"
  if stat -f "%m" "$file" >/dev/null 2>&1; then
    stat -f "%m" "$file"
  elif stat -c "%Y" "$file" >/dev/null 2>&1; then
    stat -c "%Y" "$file"
  else
    echo "Could not read modification time for: $file" >&2
    exit 1
  fi
}

find "$bundleDir" -maxdepth 1 -type f -name "*.zip" -print |
  while IFS= read -r file; do
    printf '%s\t%s\n' "$(fileMtime "$file")" "$file"
  done |
  sort -rn |
  awk -F '\t' -v keepCount="$keepCount" 'NR > keepCount {print $2}' |
  while IFS= read -r file; do
    rm -f "$file"
    echo "Removed $file"
  done
