{self, ...}: {
  flake = {
    homeModules = self.lib.mkModule {
      path = __curPos;
      options = {lib, ...}: let
        defaultType = lib.types.nullOr (lib.types.submodule {
          options = {
            desktop = lib.mkOption {
              type = lib.types.str;
              description = "Path / name of the .desktop file associated with the application.";
            };
            exec = lib.mkOption {
              type = lib.types.str;
              description = "Path / name of the executable file associated with the application.";
            };
          };
        });
        mkDefaultOption = name:
          lib.mkOption {
            default = null;
            description = "Default ${name}";
            type = defaultType;
          };
      in {
        terminal = mkDefaultOption "terminal emulator";
        textEditor = {
          terminal = mkDefaultOption "terminal text editor";
        };
      };
      config = {
        # TODO: Set default apps
      };
    };
  };
}
