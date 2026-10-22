#!/bin/zsh
set -euo pipefail

checks_dir=${0:A:h}
week_dir=${checks_dir:h}
build_dir=$(mktemp -d /tmp/progresspics-checks-XXXXXX)
trap 'rm -rf "$build_dir"' EXIT

xcrun swiftc -parse-as-library -target "$(uname -m)-apple-macosx14.0" \
  "$week_dir/ProgressPics/ProgressPics/PhotoProcessing.swift" \
  "$checks_dir/PhotoChecks.swift" \
  -o "$build_dir/photo-checks"

"$build_dir/photo-checks"
