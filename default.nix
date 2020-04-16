# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> {} }:

rec {
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  # Packages/updates accepted to nixpkgs/master, but need the update
  lib-scs = pkgs.callPackage ./pkgs/libraries/scs { };

  # New/unstable packages below
  libcint = pkgs.callPackage ./pkgs/libraries/libcint { };
  xcfun = pkgs.callPackage ./pkgs/libraries/xcfun { };

  python3Packages = pkgs.recurseIntoAttrs rec {
    # New packages NOT in NixOS/nixpkgs (and likely never will be)
    nose-timer = pkgs.python3.pkgs.callPackage ./pkgs/python-modules/nose-timer { };
    pyscf = pkgs.python3.pkgs.callPackage ./pkgs/python-modules/pyscf { inherit libcint xcfun; };
    pygsti = pkgs.python3.pkgs.callPackage ./pkgs/python-modules/pygsti { inherit cvxpy nose-timer; };
    pygsti-cirq = pygsti.overrideAttrs (oldAttrs: {
      version = "unstable-2020-04-20";
      src = pkgs.fetchFromGitHub {
        owner = "pyGSTio";
        repo = "pygsti";
        rev = "79ff1467c79a33d3afb05831f78202dfc798b4a1";
        sha256 = "1dp6w5rh6kddxa5hp3kr249xnmbjpn6jdrpppsbm4hrfw9yh6hjw";
      };
    });

    # Following have been PR'd to Nixpkgs, just not made it to release yet.
    cvxpy = pkgs.python3.pkgs.callPackage ./pkgs/python-modules/cvxpy { inherit ecos osqp ; inherit (python3Packages) scs; };
    ecos = pkgs.python3.pkgs.callPackage ./pkgs/python-modules/ecos { };
    osqp = pkgs.python3.pkgs.callPackage ./pkgs/python-modules/osqp { };
    scs = pkgs.python3.pkgs.callPackage ./pkgs/python-modules/scs { scs = lib-scs; };

    # Following are in nixpkgs, but need more recent version
    arrow = pkgs.python3.pkgs.callPackage ./pkgs/python-modules/arrow { };
    dill = pkgs.python3.pkgs.callPackage ./pkgs/python-modules/dill { };
    marshmallow = pkgs.python3.pkgs.callPackage ./pkgs/python-modules/marshmallow { };
    pybind11 = pkgs.python3.pkgs.callPackage ./pkgs/python-modules/pybind11 { };

    # Qiskit new packages or updates over what's in nixpkgs, in rough build order. All exist in nixpkgs, but only as of ~20.03
    dlx = pkgs.python3.pkgs.callPackage ./pkgs/python-modules/dlx { };
    docloud = pkgs.python3.pkgs.callPackage ./pkgs/python-modules/docloud { };
    docplex = pkgs.python3.pkgs.callPackage ./pkgs/python-modules/docplex { inherit docloud; };
    fastdtw = pkgs.python3.pkgs.callPackage ./pkgs/python-modules/fastdtw { };
    fastjsonschema = pkgs.python3.pkgs.callPackage ./pkgs/python-modules/fastjsonschema { };
    ipyvue = pkgs.python3.pkgs.callPackage ./pkgs/python-modules/ipyvue { };
    ipyvuetify = pkgs.python3.pkgs.callPackage ./pkgs/python-modules/ipyvuetify { inherit ipyvue; };
    marshmallow-polyfield = pkgs.python3.pkgs.callPackage ./pkgs/python-modules/marshmallow-polyfield { inherit marshmallow ; };
    pproxy = pkgs.python3.pkgs.callPackage ./pkgs/python-modules/pproxy { };
    python-constraint = pkgs.python3.pkgs.callPackage ./pkgs/python-modules/python-constraint { };
    pylatexenc = pkgs.python3.pkgs.callPackage ./pkgs/python-modules/pylatexenc { };
    retworkx = pkgs.python3.pkgs.callPackage ./pkgs/python-modules/retworkx { isPy38 = false; };

  };

}
