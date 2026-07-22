{self, ...}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    packages.niri-scripts = pkgs.rustPlatform.buildRustPackage (let
      manifest = lib.importTOML ./Cargo.toml;
    in {
      pname = manifest.package.name;
      version = manifest.package.version;
      cargoLock.lockFile = ./Cargo.lock;
      src = lib.cleanSource ./.;
    });
  };
}
