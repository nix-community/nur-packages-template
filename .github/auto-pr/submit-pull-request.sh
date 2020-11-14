#!/usr/bin/env bash
set -e

pname=$(basename $1)

git log -5 --oneline --graph --decorate --all
echo ...

new_commits=$(git rev-list --count HEAD ^$GITHUB_SHA)
if [ $new_commits -eq 0 ] ; then
    echo "👌 everything is up to date"
    exit 0
fi

actual_pr=$(hub pr list -h "update/$pname")
if [ -z "$actual_pr" ] ; then
  echo "🎉 Opening new pull request"
  hub pull-request \
      --no-edit \
      --assign jeremiehuchet \
      --push \
      --base main
else
  echo "📄 A pull request is already opened:"
  echo $actual_pr
  git fetch origin update/$pname
  diff=$(git diff HEAD origin/update/$pname)
  if [ -z "$diff" ] ; then
    echo "  🙅‍♂️ there is no additional change"
  else
    echo "  → pushing new changes"
    git push origin update/$pname --force-with-lease
  fi
fi