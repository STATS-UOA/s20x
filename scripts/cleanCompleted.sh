#!/usr/bin/env bash
set -euo pipefail

keepCount="${1:-1}"

if [[ ! "$keepCount" =~ ^[1-9][0-9]*$ ]]; then
  echo "Usage: $0 [number_to_keep]"
  exit 1
fi

scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mapfile -t files < <(find "$scriptDir" -maxdepth 1 -type f -name "*_completed.zip" -print0 |
  xargs -0 ls -t 2>/dev/null || true)

if (( ${#files[@]} <= keepCount )); then
  echo "Nothing to remove."
  exit 0
fi

for file in "${files[@]:keepCount}"; do
  rm -f "$file"
  echo "Removed $file"
done