{self, ...}: {
  flake = {
    homeModules = self.lib.mkModule {
      path = __curPos;
      options = {
        lib,
        config,
        ...
      }: let
        number = lib.types.oneOf [lib.types.int lib.types.float];
      in
        lib.mkOption {
          description = "List of all monitors and how they should be configured.";
          default = [];
          type = lib.types.listOf (lib.types.submodule {
            options = {
              name = lib.mkOption {
                description = "Selector of the monitor.";
                type = lib.types.str;
              };
              enable = lib.mkEnableOption "this monitor" // {default = true;};
              primary = lib.mkOption {
                description = "Whether this monitor should be primary.";
                type = lib.types.bool;
                default = false;
              };
              scale = lib.mkOption {
                description = "Scale of the output. `null` for automatic.";
                type = lib.types.nullOr number;
                default = null;
              };
              transform = {
                flipped = lib.mkOption {
                  type = lib.types.bool;
                  description = "Whether to flip this monitor vertically.";
                  default = false;
                };
                rotation = lib.mkOption {
                  type = lib.types.enum [0 90 180 270];
                  description = "Counter-clockwise rotation.";
                  default = 0;
                };
              };
              position = lib.mkOption {
                type = lib.types.nullOr (lib.types.submodule {
                  options = {
                    x = lib.mkOption {
                      type = lib.types.int;
                      description = "Horizontal position.";
                    };
                    y = lib.mkOption {
                      type = lib.types.int;
                      description = "Vertical position.";
                    };
                  };
                });
                description = "Logical position.";
                default = null;
              };
              mode = lib.mkOption {
                type = lib.types.nullOr (lib.types.submodule {
                  options = {
                    width = lib.mkOption {
                      type = lib.types.int;
                      description = "Width in pixels.";
                    };
                    height = lib.mkOption {
                      type = lib.types.int;
                      description = "Height in pixels.";
                    };
                    refresh = lib.mkOption {
                      type = lib.types.nullOr lib.types.float;
                      description = "Refresh rate (precise to 3 digits). `null` for automatic.";
                      default = null;
                    };
                  };
                });
                description = "Logical position.";
                default = null;
              };
            };
          });
        };
    };
  };
}
