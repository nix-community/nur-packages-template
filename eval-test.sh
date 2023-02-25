#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash git jq

cd "$(dirname "$0")"

source_repo_path=$(readlink -f .)
source_repo_url="file://$source_repo_path"

tempdir=$(mktemp -d --suffix=-nur-eval-test)

# create a local clone, so we use only committed files
repo_path=$tempdir/repo
mkdir -p $repo_path
repo_url=file://$repo_path
repo_commit=$(git -C . rev-parse HEAD)
git -C $repo_path init --quiet
git -C $repo_path remote add repo "$source_repo_url"
git -C $repo_path fetch --quiet --update-shallow repo $repo_commit
git -C $repo_path checkout --quiet $repo_commit

# the actual value of repo.file is stored in
# https://github.com/nix-community/NUR/blob/master/repos.json
repo_file=default.nix
if [ -e $repo_path/flake.nix ]; then
  repo_file=flake.nix
fi

repo_src=$repo_path/$repo_file
echo "repo_src: $repo_src"

EVALREPO_PATH=$tempdir/lib/evalRepo.nix
mkdir -p $(dirname $EVALREPO_PATH)
# https://github.com/nix-community/NUR/blob/master/lib/evalRepo.nix
cat >$EVALREPO_PATH <<'EOF'
{ name
, url
, src
, pkgs # Do not use this for anything other than passing it along as an argument to the repository
, lib
}:
let

  prettyName = "[32;1m${name}[0m";

  # Arguments passed to each repositories default.nix
  passedArgs = {
    pkgs = if pkgs != null then pkgs else throw ''
      NUR import call didn't receive a pkgs argument, but the evaluation of NUR's ${prettyName} repository requires it.

      This is either because
        - You're trying to use a [1mpackage[0m from that repository, but didn't pass a `pkgs` argument to the NUR import.
          In that case, refer to the installation instructions at https://github.com/nix-community/nur#installation on how to properly import NUR

        - You're trying to use a [1mmodule[0m/[1moverlay[0m from that repository, but it didn't properly declare their module.
          In that case, inform the maintainer of the repository: ${url}
    '';
  };

  expr = import src;
  args = builtins.functionArgs expr;
  # True if not all arguments are either passed by default (e.g. pkgs) or defaulted (e.g. foo ? 10)
  usesCallPackage = ! lib.all (arg: lib.elem arg (lib.attrNames passedArgs) || args.${arg}) (lib.attrNames args);

in if usesCallPackage then throw ''
    NUR repository ${prettyName} is using the deprecated callPackage syntax which
    might result in infinite recursion when used with NixOS modules.
  '' else expr (builtins.intersectAttrs args passedArgs)
EOF

repo_name=my-nur-packages

eval_path=$tempdir/default.nix
cat >$eval_path <<EOF
with import <nixpkgs> {};
import $EVALREPO_PATH {
  name = "$repo_name";
  url = "$repo_url";
  src = $repo_src;
  inherit pkgs lib;
}
EOF



# evaluate the repo
# based on https://github.com/nix-community/NUR/blob/master/ci/nur/update.py

nixpkgs_path=$(nix-instantiate --find-file nixpkgs)

a=()
a+=(nix-env)
a+=(-f "$eval_path")
a+=(-qa '*')
a+=(--meta)
a+=(--json)
a+=(--allowed-uris https://static.rust-lang.org)
a+=(--option restrict-eval true)
a+=(--option allow-import-from-derivation true)
a+=(--drv-path)
a+=(--show-trace)
#a+=(--verbose)
a+=(-I nixpkgs=$nixpkgs_path)
a+=(-I "$repo_path")
a+=(-I "$eval_path")
a+=(-I "$EVALREPO_PATH")

# passthru args to nix-env, for example "--verbose"
a+=("$@")

export NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1

# capture stdout with package list
# show stderr with eval errors
result=0
if packages_json=$("${a[@]}"); then
  echo eval ok
  echo
  echo your packages:
  echo "$packages_json" | jq -r 'values | .[].name'
else
  result=$?
  echo eval fail
fi

rm -rf $tempdir
exit $result
