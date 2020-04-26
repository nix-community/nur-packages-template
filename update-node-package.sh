#!/usr/bin/env bash
set -e

basedir=$(cd "$(dirname "$0")" ; pwd)
package_json=$(basename $1)
packagedir=$(dirname "$1")
cd "$packagedir"

quit() {
  echo "$1"
  exit 0
}
fail() {
  echo "$1" >&2
  exit 1
}

git diff --exit-code || fail "🧹 git workspace must be clean"

# use master branch as reference to compare current version vs latest
git checkout master

# check latest version against old version stored in the package.json file
pname=$(jq -r '.name' "$package_json")
old_version=$(jq -r '.version' "$package_json")
latest_version=$(curl -s "https://registry.npmjs.org/$pname" | jq -r '."dist-tags".latest')

if [ "$old_version" == "$latest_version" ] ; then
  quit "✅ $pname is up to date ($old_version)"
fi

echo "🎉 A new version is available for $pname: $old_version → $latest_version"

# update package.json
jq ".version = \"$latest_version\" | .dependencies.\"$pname\" = \"$latest_version\"" $package_json > $package_json.new
mv $package_json.new $package_json

# update nix package definition
node2nix --strip-optional-dependencies 2>&1 | tail
cp "$basedir/node2nix-fix-template.nix" fixed.nix

# commit changes to git
git diff --exit-code && quit "✅ git workspace is still clean: nothing to update"

git checkout -b "$pname-$latest_version"
git add .
git commit -m "⬆️ $pname $old_version → $latest_version"
