pkgs: let
  lib = pkgs.lib;
  manifest = lib.importTOML ./Cargo.toml;
in
  pkgs.rustPlatform.buildRustPackage {
    pname = manifest.package.name;
    version = manifest.package.version;
    cargoLock.lockFile = ./Cargo.lock;
    src = lib.cleanSource ./.;
  }
