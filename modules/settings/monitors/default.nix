{libModule, lib, ...}:
let
  inherit (lib) types;
  number = types.oneOf [ types.int types.float ];
in libModule.mkModule {
  path = ["settings" "monitors"];
  options = lib.mkOption {
    description = "List of all monitors and how they should be configured.";
    default = [];
    type = types.listOf (types.submodule {
      options = {
        name = lib.mkOption {
          description = "Selector of the monitor.";
          type = types.str;
        };
        enable = lib.mkEnableOption "this monitor" // { default = true; };
        primary = lib.mkOption {
          description = "Whether this monitor should be primary.";
          type = types.bool;
          default = false;
        };
        scale = lib.mkOption {
          description = "Scale of the output. `null` for automatic.";
          type = types.nullOr number;
          default = null;
        };
        transform = {
          flipped = lib.mkOption {
            type = types.bool;
            description = "Whether to flip this monitor vertically.";
            default = false;
          };
          rotation = lib.mkOption {
            type = types.enum [0 90 180 270];
            description = "Counter-clockwise rotation.";
            default = 0;
          };
        };
        position = lib.mkOption {
          type = types.nullOr (types.submodule {
            options = {
              x = lib.mkOption {
                type = types.int;
                description = "Horizontal position.";
              };
              y = lib.mkOption {
                type = types.int;
                description = "Vertical position.";
              };
            };
          });
          description = "Logical position.";
          default = null;
        };
        mode = lib.mkOption {
          type = types.nullOr (types.submodule {
            options = {
              width = lib.mkOption {
                type = types.int;
                description = "Width in pixels.";
              };
              height = lib.mkOption {
                type = types.int;
                description = "Height in pixels.";
              };
              refresh = lib.mkOption {
                type = types.nullOr types.float;
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
}
