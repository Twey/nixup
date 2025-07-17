# `nixup`

`nixup` is a tool to provide [rustup](https://rustup.rs/)-style
command wrappers for Rust toolchains, but provided by Nix.

Like rustup, it supports switching toolchains in a lightweight way by
passing `+name` as the first argument to the command.  Unlike rustup,
it supports declaratively specifying multiple toolchains with names of
your choice.

For example, `cargo +nightly build` will execute the command `cargo
build` with the `nightly` toolchain in the path.

The special toolchain name `default` is used by default if no
toolchain name is provided on the command line.  If no `default` is
available and no toolchain name is provided, `nixup` will fail.

## Usage

`nixup` is packaged as a flake whose `lib.default` output is a
function that takes an attrset of `{ name = toolchain; … }`.  For
example, using
[`oxalica/rust-overlay`](https://github.com/oxalica/rust-overlay):

```nix
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
```

```shellsession
$ ./result/bin/cargo --version
cargo 1.88.0 (873a06493 2025-05-10)

$ ./result/bin/cargo +nightly --version
cargo 1.90.0-nightly (6833aa715 2025-07-13)
```
