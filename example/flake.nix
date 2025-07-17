{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    nixup.url = "/home/twey/dev/nixup";
  };

  outputs = inputs:
    let
      pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        overlays = [ (import inputs.rust-overlay) ];
      };
    in {
      packages.x86_64-linux.default = pkgs.callPackage inputs.nixup { } {
        default = pkgs.rust-bin.stable.latest.default;
        nightly = pkgs.rust-bin.nightly.latest.default;
      };
    };
}
