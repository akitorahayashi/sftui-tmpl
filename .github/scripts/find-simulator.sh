#!/bin/bash

set -euo pipefail

# 依存コマンドの存在確認
for cmd in xcrun jq; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: '$cmd' is required but not installed." >&2
    exit 1
  fi
done

# 利用可能な最新のiOSシミュレータのUDIDを取得
SIMULATOR_UDID=$(xcrun simctl list devices available --json | \
  jq -r '
    .devices
    | to_entries[]
    | select(.key | startswith("com.apple.CoreSimulator.SimRuntime.iOS"))
    | .value[]
    | select(.isAvailable == true and (.name | contains("iPhone")))
    | {udid, runtime: .key}
  ' | \
  sort -rV -k2,2 | \
  awk "{print \$1}" | \
  head -n 1)

if [ -z "$SIMULATOR_UDID" ]; then
    echo "Error: No available iOS simulator found." >&2
    exit 1
fi

echo "Using simulator: $SIMULATOR_UDID" >&2
printf '%s\n' "$SIMULATOR_UDID" 