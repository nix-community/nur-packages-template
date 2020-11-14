#!/usr/bin/env bash
set -e

source "$TOOLS"

pkgdir=$PWD/$1

cd "$pkgdir"
owner=$(jq -r '.owner' github-release-assets.json)
repo=$(jq -r '.repo' github-release-assets.json)
check_cmd=$(jq -r '.check_cmd' github-release-assets.json)
old_version=$(jq -r '.ref' github-release-assets.json)
latest_version=$(hub api "repos/$owner/$repo/releases/latest" | jq -r .tag_name)

if [ "$old_version" == "$latest_version" ] ; then
  quit "✅ $repo is up to date ($old_version)"
fi

# need to fake a git repository so hub cli can query info about it
cd "$(mktemp -d --tmpdir "$repo-XXX.git")"
git init .
git remote add origin "https://github.com/$owner/$repo"
hub release download "$latest_version"

# verify checksums
eval "$check_cmd"

ASSETS_JSON=$(mktemp --tmpdir "$repo-XXX.json")
for asset in * ; do
  url=https://github.com/$owner/$repo/releases/download/$latest_version/$asset
  sha256=$(nix-prefetch-url "$url")
  cat - <<EOF >> "$ASSETS_JSON"
  "$asset": {
    "url" : "$url",
    "hash": "sha256:$sha256"
  },
EOF
done
sed -i '$ s/,$//' "$ASSETS_JSON"

# update assets descriptor file
cp "$pkgdir/github-release-assets.json" .
jq --arg version "$latest_version" \
    --argjson assets "{ $(cat "$ASSETS_JSON") }" \
    '.ref = $version | .assets = $assets' github-release-assets.json > "$pkgdir/github-release-assets.json"

export_version_vars "$old_version" "$latest_version"