{
  lib,
  flake-parts-lib,
  config,
  ...
}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption (
    {config, ...}: {
      options.homeConfigurations = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.raw;
        default = {};
        description = ''
          Mergeable `flake.homeConfigurations` that do not require hard coding `pkgs`.

          Uses `legacyPackages.homeConfigurations` under the hood.
          Even though I'm outputting a package, home-manager still checks for packages.<system>.homeConfigurations.<name> and accepts it.
          [Issue](https://github.com/nix-community/home-manager/issues/3075#issuecomment-3037360368).
        '';
      };
      config = {
        legacyPackages.homeConfigurations = config.homeConfigurations;
      };
    }
  );
}
