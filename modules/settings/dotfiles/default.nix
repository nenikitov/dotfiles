{self, ...}: {
  flake = {
    homeModules = self.lib.mkModule {
      path = __curPos;
      options = {
        lib,
        config,
        ...
      }: let
        inherit (lib) types;
      in {
        path = lib.mkOption {
          type = types.path;
          apply = builtins.toString;
          default = "${config.xdg.configHome}/home-manager";
          description = "Path to home-manager configuration directory.";
        };
      };
    };
  };
}
