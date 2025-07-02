#!/bin/bash

set -euo pipefail

# 利用可能で最初に見つかったiPhoneシミュレータのUDIDを取得
SIMULATOR_UDID=$(xcrun simctl list devices available | \
  grep "iPhone" | \
  grep -E "\([A-F0-9-]{36}\)" | \
  head -n 1 | \
  sed -E 's/.*\(([A-F0-9-]{36})\).*/\1/')

if [ -z "$SIMULATOR_UDID" ]; then
    echo "Error: No available iPhone simulator found." >&2
    exit 1
fi

echo "Using simulator: $SIMULATOR_UDID" >&2
printf '%s\n' "$SIMULATOR_UDID" 