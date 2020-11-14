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
  old_version=$1
  new_version=$2
  pname=$(basename "$PWD")

  git diff --exit-code && quit "✅ git workspace is still clean: nothing to update"

  echo "🎉 A new version is available for $pname: $old_version → $new_version"
  git checkout -b "update/$pname"
  git add .
  git commit -m "⬆️ $pname $old_version → $new_version"
}

# git workspace must be clean
git diff --exit-code || fail "🧹 git workspace must be clean"

# configure git
git config user.email "$GITHUB_ACTOR@users.noreply.github.com"
git config user.name "Github Actions"

# make remote "origin" writeable
git remote set-url --push origin "git@github.com:$GITHUB_REPOSITORY.git"