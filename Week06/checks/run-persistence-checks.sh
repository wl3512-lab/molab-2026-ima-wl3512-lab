#!/bin/zsh
set -euo pipefail

checks_dir=${0:A:h}
week_dir=${checks_dir:h}
test_home=$(mktemp -d /tmp/idine-persistence-XXXXXX)
trap 'rm -rf "$test_home"' EXIT

xcrun swiftc -parse-as-library -target "$(uname -m)-apple-macosx14.0" \
  "$week_dir/iDine/iDine/Model/MenuSection.swift" \
  "$week_dir/iDine/iDine/Model/Order.swift" \
  "$checks_dir/OrderPersistenceChecks.swift" \
  -o "$test_home/persistence-checks"

CFFIXED_USER_HOME="$test_home" "$test_home/persistence-checks" "$test_home"
