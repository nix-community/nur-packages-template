#!/usr/bin/env bash
set -e

source "$TOOLS"

pkgdir=$1
cd "$pkgdir"

owner=$(jq -r '.owner' github.json)
repo=$(jq -r '.repo' github.json)
refname=$(jq -r '.ref' github.json)
old_rev=$(jq -r '.rev' github.json)

# if it's a branch
latest_rev=$(git ls-remote --heads "https://github.com/$owner/$repo.git" "$refname" | cut -f1)
if [ -n "$latest_rev" ] ; then
  if [ "$old_rev" != "$latest_rev" ] ; then
    old_version=$refname@${old_rev:0:7}
    new_version=${latest_rev:0:7}
    nix-prefetch-github --rev "$refname" "$owner" "$repo" | jq ".ref = \"$refname\"" > github.json
  fi
else
  # it's not a branch, assuming we use the latest released tag
  latest_tag=$(hub api "repos/$owner/$repo/releases/latest" | jq -r .tag_name)
  if [ "$refname" != "$latest_tag" ] ; then
    old_version=$refname
    new_version=$latest_tag
    nix-prefetch-github --rev "$latest_tag" "$owner" "$repo" \
        | jq ".ref = \"$latest_tag\"" > github.json
  fi
fi

export_version_vars $old_version $new_version