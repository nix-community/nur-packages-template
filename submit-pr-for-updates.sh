#!/usr/bin/env bash
set -e

git clone git@github.com:$TRAVIS_REPO_SLUG.git nur-packages

cd nur-packages
./pkgs/node-packages/update-derivations.sh

git status --porcelain
