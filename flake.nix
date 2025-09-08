{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs_25_05.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      flake =
        { lib, ... }:
        rec {
          currentFingerprint = import ./lib/fingerprint.nix;
          estimatedCurrentSystems = database.estimateSystemsFor currentFingerprint;
          database = import ./database lib;
        };

      perSystem =
        {
          config,
          system,
          pkgs,
          lib,
          ...
        }:
        let
          pkgs_25_05 = import inputs.nixpkgs_25_05 {
            inherit system;
          };

          # nixVersions = pkgs_25_05.nixVersions.extend (
          #   _final: prev: {
          #     nixComponents_2_30 = prev.nixComponents_2_30.overrideScope (
          #       _finalScope: _prevScope: { stdenv = pkgs_25_05.llvm-clangStdenv; }
          #     );
          #   }
          # );
        in
        {
          packages = {
            save-fingerprint = pkgs.callPackage ./pkgs/save-fingerprint.nix { };
            nix_2_30 = pkgs_25_05.nixVersions.nix_2_30;
          };

          apps.analyze-full.program = lib.getExe (
            pkgs.writeShellApplication {
              name = "analyze-full";
              text = ''
                ${lib.getExe (config.packages.save-fingerprint.override { nix = config.packages.nix_2_30; })}
              '';
            }
          );
        };

      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    };
}
