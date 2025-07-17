{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs = { nixpkgs, ... }: {
    lib.nixup = nixpkgs.callPackage ./. { };
  };
}
