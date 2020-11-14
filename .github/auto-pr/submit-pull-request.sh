#!/usr/bin/env bash
set -e

pname=$(basename $1)

if [ -s "$(git diff)" ] ; then
    quit "👌 everything is up to date"
fi

commit_optional_changes
git log -5 --oneline --graph --decorate --all

# make remote "origin" writeable
git remote set-url --push origin "git@github.com:$GITHUB_REPOSITORY.git"

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
