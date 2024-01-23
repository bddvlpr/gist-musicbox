{
  description = "Updates a given GitHub Gist with your music statistics";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    flake-parts,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];
      perSystem = {
        config,
        pkgs,
        ...
      }: {
        formatter = pkgs.alejandra;

        packages = rec {
          default = pkgs.callPackage ./default.nix {};
          gist-musicbox = default;
        };
      };
      flake = {
        nixosModules = rec {
          default = import ./module.nix self;
          gist-musicbox = default;
        };
      };
    };
}
