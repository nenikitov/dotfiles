{
  lib,
  flake-parts-lib,
  ...
}: {
  options.flake = flake-parts-lib.mkSubmoduleOptions {
    lib = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.raw;
      default = {};
      description = ''
        Library functions or constants exposed by the flake.
      '';
    };
  };
}
