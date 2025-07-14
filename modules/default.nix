{libModule, ...}: {
  imports = libModule.scanDir {
    dir = ./.;
    exclude = ./default.nix;
  };
}
