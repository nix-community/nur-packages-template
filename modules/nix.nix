{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.knopki.nix;
  selfCachix = {
    url = https://knopki-nixexprs.cachix.org;
    pubKey = "knopki-nixexprs.cachix.org-1:8POFjWFaXKqJSn+KzEGuBmRyFnB19QFkm62zbjo9eto=";
  };
  rebuild-throw = pkgs.writeText "rebuild-throw.nix"
    ''throw "I'm sorry Dave, I'm afraid I can't do that... Please specify NIX_PATH with nixos-config."'';
in
{
  options.knopki.nix = {
    enable = mkEnableOption "Enable nix module";
    gcKeep = (mkEnableOption "Keep env, derivations and outputs");
    gcAutorun = (mkEnableOption "Run GC nightly") // { default = true; };
    gcAutorunKeepDays = mkOption {
      default = 30;
      example = 15;
      description = "Delete generations older then X days";
      type = types.int;
    };
    gcMinFree = mkOption {
      default = 1024 * 1024 * 1024 * 10;
      example = 1024 * 1024 * 1024;
      description = "When free disk space in /nix/store drops below min-free during a build, Nix performs a garbage-collection. 0 for disable. 10GB by default.";
      type = types.int;
    };
    lowPriorityDaemon = (mkEnableOption "Make nix daemon run in low priority mode") // { default = true; };
    nixPathFreeze = mkEnableOption "Break /etc/nixos/configuration.nix and set NIX_PATH";
    optimiseStore = (mkEnableOption "Enable nix store autooptimisations") // { default = true; };
    setupCachix = (mkEnableOption "Enable Cachix for this repository") // { default = true; };
    trustWheelGroup = (mkEnableOption "Trust users in the @wheel group") // { default = true; };
  };

  config = mkIf cfg.enable (
    mkMerge [
      #
      # Extra nix.conf options
      #
      {
        assertions = [ { assertion = cfg.gcMinFree >= 0; message = "`knopki.nix.gcMinFree` must be >= 0`"; } ];
        nix.extraOptions = mkBefore ''
          # Like ${toString (cfg.gcMinFree * 1.0 / 1024 / 1024 / 1024)} GBs
          min-free = ${toString cfg.gcMinFree}

          # Like ${toString (cfg.gcMinFree * 2.0 / 1024 / 1024 / 1024)} GBs
          max-free = ${toString (cfg.gcMinFree * 2)}

          # Like 30 days
          tarball-ttl = ${toString (86400 * 30)}
        '';
      }

      #
      # Run GC nightly
      #
      (
        mkIf (cfg.gcAutorun) {
          assertions = [ { assertion = cfg.gcAutorunKeepDays > 0; message = "`knopki.nix.gcAutorunKeepDays` must be > 0"; } ];
          nix.gc = {
            automatic = mkDefault true;
            dates = mkDefault "weekly";
            options = mkDefault "--delete-older-than ${toString cfg.gcAutorunKeepDays}d";
          };
          systemd.timers.nix-gc.timerConfig.Persistent = mkDefault true;
        }
      )

      #
      # Keep derivations and outputs on GC
      #
      (
        mkIf (cfg.gcKeep) {
          nix.extraOptions = mkBefore ''
            keep-derivations = true
            keep-env-derivations = true
            keep-outputs = true
          '';
        }
      )

      #
      # Run nix daemon in low priority mode
      #
      (
        mkIf (cfg.lowPriorityDaemon) {
          nix = {
            daemonIONiceLevel = mkDefault 7;
            daemonNiceLevel = mkDefault 19;
          };
        }
      )

      #
      # Break /etc/nixos/configuration.nix and set NIX_PATH
      #
      (
        mkIf (cfg.nixPathFreeze) {
          environment.etc."nixos/configuration.nix".source = rebuild-throw;
          nix.nixPath = [
            "${pkgs.path}"
            "nixpkgs=${pkgs.path}"
            "nixos-config=${rebuild-throw}"
          ];
        }
      )

      #
      # Nix Store optimisation
      #
      (
        mkIf (cfg.optimiseStore) {
          nix = {
            autoOptimiseStore = mkDefault true;
            optimise.automatic = mkDefault true;
          };

          systemd.timers.nix-optimise.timerConfig.Persistent = mkDefault true;
        }
      )

      #
      # Setup Cachix for this repository
      #
      (
        mkIf (cfg.setupCachix) {
          nix = {
            binaryCachePublicKeys = mkAfter [ selfCachix.pubKey ];
            binaryCaches = mkAfter [ selfCachix.url ];
          };
        }
      )

      #
      # Trust users in the @wheel group
      #
      (
        mkIf (cfg.trustWheelGroup) {
          nix.trustedUsers = mkAfter [ "root" "@wheel" ];
        }
      )
    ]
  );
}
