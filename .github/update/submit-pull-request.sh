#!/usr/bin/env bash
set -e

source "$TOOLS"

has_changes_or_quit

pname=$(basename $1)

# configure git
git config user.email "$GITHUB_ACTOR@users.noreply.github.com"
git config user.name "Github Actions"

# make remote "origin" writeable
git remote set-url --push origin "git@github.com:$GITHUB_REPOSITORY.git"

echo "🎉 A new version is available for $pname: $old_version → $new_version"
git checkout -b "update/$pname"
git add .
git commit -m "⬆️ $pname $old_version → $new_version"

git log -5 --oneline --graph --decorate --all

actual_pr=$(hub pr list -h "update/$pname")
if [ -z "$actual_pr" ] ; then
  echo "🔀 Opening new pull request"
  hub pull-request \
      --no-edit \
      --assign jeremiehuchet \
      --push \
      --base main
else
  git fetch origin update/$pname
  echo "📄 A pull request is already opened:"
  echo " └─ $actual_pr"
  diff=$(git diff HEAD origin/update/$pname)
  if [ -z "$diff" ] ; then
    echo "      └─ 🙅‍♂️ there is no additional change"
  else
    echo "      └─ 🔃 pushing new changes"
    git push origin update/$pname --force-with-lease
  fi
fi
