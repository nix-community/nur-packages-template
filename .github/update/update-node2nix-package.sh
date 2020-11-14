#!/usr/bin/env bash
set -e

source "$TOOLS"

pkgdir=$1
cd "$pkgdir"

# check latest version against old version stored in the package.json file
pname=$(jq -r '.name' package.json)
old_version=$(jq -r '.version' package.json)
latest_version=$(curl -s "https://registry.npmjs.org/$pname" | jq -r '."dist-tags".latest')

if [ "$old_version" == "$latest_version" ] ; then
  quit "✅ $pname is up to date ($old_version)"
fi

# update package.json
jq ".version = \"$latest_version\" | .dependencies.\"$pname\" = \"$latest_version\"" package.json > package.json.new
mv package.json.new package.json

# update nix package definition
node2nix --strip-optional-dependencies 2>&1 | tail
cp "$GITDIR/.github/update/node2nix-fix-template.nix" fixed.nix

export_version_vars $old_version $latest_version