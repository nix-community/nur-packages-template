#!/usr/bin/env bash
set -e

branch=$1
git checkout $branch
hub pull-request --no-edit --push