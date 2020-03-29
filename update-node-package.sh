#!/usr/bin/env bash
set -e

package_json=$(basename $1)
packagedir=$(dirname "$1")
cd "$packagedir"

git diff --exit-code || (
  echo "git workspace must be clean" >&2
  exit 1
)
# use master branch as reference to compare current version vs latest
git checkout master

# check latest version against old version stored in the package.json file
pname=$(jq -r '.name' "$package_json")
old_version=$(jq -r '.version' "$package_json")
latest_version=$(curl -s "https://registry.npmjs.org/$pname" | jq -r '."dist-tags".latest')

if [ "$old_version" == "$latest_version" ] ; then
  echo "$pname is up to date ($old_version)"
  exit 0
fi

echo "A new version is available for $pname: $old_version → $latest_version"

# update package.json
jq ".version = \"$latest_version\" | .dependencies.\"$pname\" = \"$latest_version\"" $package_json > $package_json.new
mv $package_json.new $package_json

# update nix package definition
node2nix
sed -i "/ sources.\"$pname-$latest_version\"$/d" node-packages.nix
sed -i "s/src = \.\/\.;$/src = sources.\"$pname-$latest_version\".src;/" node-packages.nix

# commit changes to git
git checkout -b "$pname-$latest_version"
git commit -a -m "⬆️ now $old_version → $latest_version"
