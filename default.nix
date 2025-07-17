{ lib, stdenv, runCommand }:
toolchains:
let
  toolchains' = lib.attrsToList toolchains;
in stdenv.mkDerivation {
  pname = "rust-toolchain-wrapper";
  version = "0.0.1";
  src = runCommand
    "rust-toolchain-wrapper"
    {
      toolchains = lib.concatMapStringsSep
        "\n"
        ({name, value}: "toolchains[${builtins.toJSON name}]=${builtins.toJSON value}")
        toolchains';
    }
    (''
      mkdir -p $out/bin
      cp ${./wrapper.bash} $out/.wrapper
      patchShebangs $out/.wrapper
      substituteInPlace $out/.wrapper --subst-var toolchains
    '' + lib.concatMapStringsSep "\n" ({value, ...}: ''
      for f in ${value}/bin/*
      do
        ln -sf $out/.wrapper $out/bin/$(basename $f)
      done
    '') toolchains');
  meta = {
    homepage = "https://github.com/Twey/nixup";
    description = "rustup-compatible Rust toolchain wrappers using Nix";
  };
  buildPhase = ''cp -r . $out'';
}
