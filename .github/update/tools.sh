#!/usr/bin/env bash

generate_matrix() {
  local gh_pkgs_json node_pkgs_json matrix_csv
  gh_pkgs_json=$(find "$GITDIR" -type f -name github.json)
  gh_rel_assets_json=$(find "$GITDIR" -type f -name github-release-assets.json)
  node_pkgs_json=$(find "$GITDIR" -type f -name package.json)
  local first="yes"
  echo [
  for f in $gh_pkgs_json $node_pkgs_json $gh_rel_assets_json; do
    path=$(dirname "$f")
    pkgname=$(basename "$path")
    pkgdir=${path#$GITDIR/}
    updateType="unknown"
    if [ -f "$pkgdir/github.json" ] ; then
      updateType="github_src"
    elif [ -f "$pkgdir/github-release-assets.json" ] ; then
      updateType="github_rel_assets"
    elif [ -f "$pkgdir/package.json" ] ; then
      updateType="npm_src"
    elif [ -f "$pkgdir/godeps.nix"] ; then
      updateType="vgo2nix"
    fi
    if [ "$first" == "yes" ] ; then
      first="nope"
    else
      echo ","
    fi
    cat - <<EOF
  {
    "pkgname": "$pkgname",
    "pkgdir": "$pkgdir",
    "update_type": "$updateType"
  }
EOF
  done
  echo "]"
}

quit() {
  echo "$1"
  exit 0
}

fail() {
  echo "$1" >&2
  exit 1
}

has_changes_or_quit() {
  git diff --exit-code \
      && quit "✅ git workspace is still clean: nothing to update" \
      || echo "➕ changes available in workdir"
}

export_version_vars() {
  cat - <<EOF >> "$GITHUB_ENV"
old_version=$1
new_version=$2
EOF
}
