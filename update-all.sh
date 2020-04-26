#!/usr/bin/env bash
set -e

basedir=$(cd "$(dirname "$0")" ; pwd)

git clone "git@github.com:$TRAVIS_REPO_SLUG.git" nur-packages

find nur-packages -type f -name package.json | \
    xargs -I FILE "$basedir/update-node-package.sh" FILE

cd nur-packages
git for-each-ref 'refs/heads/*' --format '%(refname:short)' --no-merged master --shell | \
    xargs -I BRANCH "$basedir/submit-pull-request.sh" BRANCH