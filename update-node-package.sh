#!/usr/bin/env bash
set -e

basedir=$(cd "$(dirname "$0")" ; pwd)
package_json=$(basename $1)
packagedir=$(dirname "$1")
cd "$packagedir"
source "$basedir/utils.sh"

# check latest version against old version stored in the package.json file
pname=$(jq -r '.name' "$package_json")
old_version=$(jq -r '.version' "$package_json")
latest_version=$(curl -s "https://registry.npmjs.org/$pname" | jq -r '."dist-tags".latest')

if [ "$old_version" == "$latest_version" ] ; then
  quit "✅ $pname is up to date ($old_version)"
fi

# update package.json
jq ".version = \"$latest_version\" | .dependencies.\"$pname\" = \"$latest_version\"" $package_json > $package_json.new
mv $package_json.new $package_json

# update nix package definition
node2nix --strip-optional-dependencies 2>&1 | tail
cp "$basedir/node2nix-fix-template.nix" fixed.nix

commit_optional_changes $pname $old_version $latest_version
