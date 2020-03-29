#!/usr/bin/env sh
set -e

basedir="$(cd "$(dirname $0)" ; pwd)"

function generate_package_json() {
  cat - <<EOF
{
  "name": "$1",
  "version": "$2",
  "dependencies": {
    "$1": "$2"
  }
}
EOF
}

for packagedir in $(find "$basedir" -mindepth 1 -maxdepth 1 -type d) ; do

  pname=$(basename "$packagedir")
  latest_version=$(curl -s "https://registry.npmjs.org/$pname" | jq -r '."dist-tags".latest')

  generate_package_json "$pname" "$latest_version" > "$packagedir/package.json"

  (
    cd "$packagedir"
    node2nix $NODE_2_NIX_OPTS
    sed -i "/ sources.\"$pname-$latest_version\"$/d" node-packages.nix
    sed -i "s/src = \.\/\.;$/src = sources.\"$pname-$latest_version\".src;/" node-packages.nix
  )
done