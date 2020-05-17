#!/usr/bin/env bash

quit() {
  echo "$1"
  exit 0
}

fail() {
  echo "$1" >&2
  exit 1
}

commit_optional_changes() {
  pname=$1
  old_version=$2
  new_version=$3

  git diff --exit-code && quit "✅ git workspace is still clean: nothing to update"

  echo "🎉 A new version is available for $pname: $old_version → $new_version"
  git checkout -b "$pname-$new_version"
  git add .
  git commit -m "⬆️ $pname $old_version → $new_version"
}

# git workspace must be clean
git diff --exit-code || fail "🧹 git workspace must be clean"

# use master branch as reference to compare current version vs latest
git checkout master


