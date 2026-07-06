#!/bin/sh
set -eu

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT="$ROOT_DIR/CalmTide.xcodeproj"

if [ "${1:-}" = "--open" ]; then
  open "$PROJECT"
  exit 0
fi

if [ "${1:-}" = "--mac" ]; then
  xcodebuild \
    -project "$PROJECT" \
    -scheme CalmTide \
    -destination generic/platform=macOS \
    CODE_SIGNING_ALLOWED=NO \
    build
  exit 0
fi

xcodebuild \
  -project "$PROJECT" \
  -scheme CalmTide \
  -destination generic/platform=iOS \
  CODE_SIGNING_ALLOWED=NO \
  build
