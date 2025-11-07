{pkgs, ...}: let
  manifest = pkgs.lib.importTOML ./Cargo.toml;
in
  pkgs.rustPlatform.buildRustPackage {
    pname = manifest.package.name;
    version = manifest.package.version;
    cargoLock.lockFile = ./Cargo.lock;
    src = pkgs.lib.cleanSource ./.;
  }
